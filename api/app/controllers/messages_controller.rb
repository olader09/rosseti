class MessagesController < APIBaseController
  authorize_resource
  before_action :auth_user

  def index
    if current_user.present?
      messages = Message.where(chat_id: current_user.chat.id).order(created_at: :desc).page(params[:page])
      if messages.empty?
        render status: :no_content
      else
        render json: messages, status: :ok
      end
    end
  end

  def show
    if current_superuser.present?
      messages = Message.where(chat_id: params[:id]).order(created_at: :desc).page(params[:page])
      if messages.empty?
        render status: :no_content
      else
        render json: messages, status: :ok
      end
    else
      render json: { "admin": 'no unauthorized' }, status: 401
    end
  end

  def destroy
    message = Message.find(params[:id])
    if message.errors.blank?
      message.delete
      message.remove_picture!
      message.save
      render status: :ok
    else
      render json: message.errors, status: :bad_request
    end
  end
end
