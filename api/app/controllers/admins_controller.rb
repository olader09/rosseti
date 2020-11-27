class AdminsController < APIBaseController
  before_action :load_superuser
  authorize_resource
  before_action :auth_user

  def show
    render json: @superuser.to_json(except: [:password_digest])
  end

  def update
    @superuser.update(update_superuser_params)
    if @superuser.errors.blank?
      render json: @superuser, except: [:password_digest], status: :ok
    else
      render json: @superuser.errors, status: :bad_request
    end
  end

  def online_users
    online_users = User.where(online: true).count
      render json: {users_count_online: online_users}, status: :ok
  end

  def show_user
    user = User.find(params[:id])
    if user.errors.blank?
      render json: user, except: [:password_digest], status: :ok
    else
      render status: :bad_request
    end
  end

  def push_message_to_all
    if params[:type_message].present? && params[:type_message] == 1
      response = PushNotificationMailingJob.perform_later(params[:content], @superuser, params[:type_message])
      render json: response, status: :ok
    elsif params[:type_message].present? && params[:picture].present? && params[:type_message] == 2
      #Здесь должна быть рассылка фото
      render status: :accepted
    else
      render json: { "error": 'need required params' }, status: :bad_request
    end
  end

  def block_user
    user = User.where(phone_number: params['phone_number'])
    if user.present?
      user.update(banned: true, reason: params['reason'])
      render json: user, status: :ok
    else
      render status: :not_found
    end
  end

  def unblock_user
    user = User.where(phone_number: params['phone_number'])
    if user.present?
      user.update(banned: false, reason: '')
      render json: user, status: :ok
    else
      render status: :not_found
    end
  end

  def get_taxi_url
    if params[:latitude].present? && params[:longitude].present?
      delivery_shop = Delivery.first
      url = "https://3.redirect.appmetrica.yandex.com/route?start-lat=#{delivery_shop.latitude}&start-lon=#{delivery_shop.longitude}&end-lat=#{params[:latitude]}&end-lon=#{params[:longitude]}&appmetrica_tracking_id=25395763362139037"
      render json: {get_taxi_link: url}
    else
      render status: :bad_request
    end
  end

  def create_payment
    if params[:chat_id].present? && params[:value].present? && params[:phone_number].present?
      @chat_id = params[:chat_id]
      value = params[:value]
      phone_number = params[:phone_number]

      yandex_payments = YandexApiPaymentsService.new
      result = yandex_payments.create_payment(value, phone_number)

      if result[:http_status] == 200
        new_message = Message.create(content: result[:confirmation_url], chat_id: @chat_id, order_data: {price: value},sender: current_superuser, type_message: 5, pay_status: result[:status], payment_id: result[:id])
        ActionCable.server.broadcast room_id, message: new_message.content, order_data: new_message.order_data, pay_status: new_message.pay_status, payment_id: new_message.payment_id, type_message: 5, sender_type: 'Superuser'
        notify_service = PushNotificationService.new(new_message,  @superuser, value)
        notify_service.fcm_push_notification
      end
      render json: result, status: :ok
    else
      render status: :bad_request
    end
  end

  def check_payment
    if params[:id].present?
      payment_id = params[:id]
      message = Message.find_by(payment_id: payment_id)
      value = message.order_data["price"]

      yandex_payments = YandexApiPaymentsService.new
      result = yandex_payments.check_payment(payment_id)

      if result[:paid] == true && result[:status] == 'succeeded' && message.pay_status != 'succeeded'
        message.update(pay_status: 'succeeded', content: "Счет на сумму #{value} руб оплачен ✅", type_message: 1 )
        notify_service = PushNotificationService.new(message,  @superuser, value)
        notify_service.send_push_notification_of_success_pay
      end
      render json: result
    else
      render status: :bad_request
    end
  end

  protected

  def load_superuser
    @superuser = current_superuser
  end

  def default_superuser_fields
    %i[btn1 btn2 btn3 push_token login]
  end

  def update_superuser_params
    params.required(:superuser).permit(
      *default_superuser_fields
    )
  end

  def create_superuser_params
    params.required(:superuser).permit(
      *default_superuser_fields, :password
    )
  end

  def room_id
    "room_channel_#{@chat_id}"
  end
  
end
