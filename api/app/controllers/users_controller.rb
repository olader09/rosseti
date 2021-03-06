class UsersController < APIBaseController
  before_action :load_user, :auth_user, :verifing_user, except: %i[create]
  authorize_resource except: %i[create]

  def show
    render json: @user.to_json(except: %i[password_digest push_token])
  end

  def update
    @user.update(update_user_params)
    if @user.errors.blank?
      render json: @user.to_json(except: %i[password_digest push_token]), status: :ok
    else
      render json: @user.errors, status: :bad_request
    end
  end

  def create
    @user = User.create(create_user_params)
    if @user.errors.blank?
      render json: @user.to_json(except: %i[password_digest push_token]), status: :ok
    else
      render json: @user.errors, status: :bad_request
    end
  end

  protected

  def load_user
    @user = current_user
  end

  def verifing_user
    current_user.update(verify: true) if current_user.verify == false
  end

  def default_user_fields
    %i[name surname second_name push_token unit birthday education start_working post]
  end

  def update_user_params
    params.required(:user).permit(
      *default_user_fields, :password
    )
  end

  def create_user_params
    params.required(:user).permit(
      *default_user_fields, :password, :email
    )
  end
end
