class ApplicationsController < APIBaseController
  authorize_resource except: %i[index show]

  before_action :auth_user, except: %i[index show]

  def index
    applications = Application.all.order(:id).page(params[:page])
    if applications.empty?
      render status: 204
    else
      render json: applications
    end
  end

  def show
    @application = Application.find(params[:id])
    if @application.errors.blank?
      render json: @application, status: :ok
    else
      render json: @application.errors, status: :bad_request
    end
  end

  def update
    @application = Application.find(params[:id])
    @application.update(update_application_params)
    if @application.errors.blank?
      render json: @application, status: :ok
    else
      render json: @application.errors, status: :bad_request
    end
  end

  def create
    @application = Application.new(create_application_params)
    @application.user = current_user.id
    @application.save
    if @application.errors.blank?
      render json: @application, status: :ok
    else
      render json: @application.errors, status: :bad_request
    end
  end

  def destroy
    @application = Application.find(params[:id])
    if @application.errors.blank?
      @application.delete
      @application.save
      render status: :ok
    else
      render json: @application.errors, status: :bad_request
    end
  end

  protected

  def default_application_fields
    %i[title text]
  end

  def update_application_params
    params.required(:application).permit(
      *default_application_fields
    )
  end

  def create_application_params
    params.required(:application).permit(
      *default_application_fields
    )
  end
end
