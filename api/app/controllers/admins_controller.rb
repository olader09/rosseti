class AdminsController < APIBaseController
  before_action :load_admin
  authorize_resource
  before_action :auth_user

  def show
    render json: @admin.to_json(except: [:password_digest])
  end

  def update
    @admin.update(update_admin_params)
    if @admin.errors.blank?
      render json: @admin, except: [:password_digest], status: :ok
    else
      render json: @admin.errors, status: :bad_request
    end
  end


  protected

  def load_admin
    @admin = current_admin
  end

  def default_admin_fields
    %i[ push_token email]
  end

  def update_admin_params
    params.required(:admin).permit(
      *default_admin_fields
    )
  end

  def create_admin_params
    params.required(:admin).permit(
      *default_admin_fields, :password
    )
  end

  
end
