class ApplicationsController < APIBaseController
  authorize_resource
  before_action :auth_user

  def index
    @applications = Application.all.order(:id).page(params[:page])
    if @applications.empty?
      render status: 204
    else
      render json: @applications
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
    @application.user_id = current_user.id
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

  def like
    @application = Application.find(params[:id])
    if @application.likes.where(user_id: current_user.id, application_id: @application.id).blank?
      @application.users << current_user
      @application.count_likes = @application.users.count
      @application.save
      render json: @application, status: :ok
    else
      render json: @application, status: 208
    end
  end

  def dislike
    @application = Application.find(params[:id])
    if @application.likes.where(user_id: current_user.id, application_id: @application.id).blank?
      render json: @application, status: 208
    else
      @application.likes.where(user_id: current_user.id, application_id: @application.id).delete_all
      @application.count_likes = @application.users.count
      @application.save
      render json: @application, status: :ok
    end
  end

  def similar
    @application = Application.find(params[:id])
    problem = @application.problem
    title = @application.title
    similars = Application.search({
      min_score: 2,
      query: {
        dis_max: {
          queries: [
            { match: { title: title } },
            { match: { problem: problem } }
          ],
          tie_breaker: 0.5
        }
      }}).to_a
      similars.delete_at(0)
      if similars.empty?
        @application.update(uniqueness: 100) 
        render status: :no_content
      else
        similars = similars.take(3)
        scores = similars.map {|similar| similar['_score']}
        total_score = 0.0
        scores.each {|score| total_score += score}
        total_score = (total_score * 100 / 76) + 70

        @application.update(uniqueness: total_score)
        render json: similars
      end
  end

  def check_uniq
    problem = params[:problem]
    title = params[:title]
    similars = Application.search({
      min_score: 2,
      query: {
        dis_max: {
          queries: [
            { match: { title: title } },
            { match: { problem: problem } }
          ],
          tie_breaker: 0.5
        }
      }}).to_a
      similars.delete_at(0)
      if similars.empty?
        render json: {"uniqueness": 100}
      else
        similars = similars.take(3)
        scores = similars.map {|similar| similar['_score']}
        total_score = 0.0
        scores.each {|score| total_score += score}
        p total_score
        total_score = (total_score * 100 / 76) + 70
        render json: {"uniqueness": total_score}
      end
  end

  protected

  def default_application_fields
    %i[title category problem decision impact economy other_authors expenses stages file direction_activity status]
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
