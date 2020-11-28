class ChatsController < APIBaseController
  authorize_resource
  before_action :auth_user

  def index
    if current_superuser.present?
      chats = Chat.joins(:user).where(users: {verify: true}).order(updated_at: :desc).page(params[:page])
      if chats.empty?
        render status: :no_content
      else
        render json: chats
      end
    else
      render json: { "admin": 'no unauthorized' }, status: 401
    end
  end

  def show
    if current_superuser.present?
      messages = Message.where(chat_id: params[:id])
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
    chat = Chat.find(params[:id])
    if chat.errors.blank?
      chat.destroy
      render status: :ok
    else
      render json: chat.errors, status: :bad_request
    end
  end
end
