class APIBaseController < ActionController::API
  before_action :init_redis
  include Knock::Authenticable
  # Здесь была рассылка
  def current_ability
    @current_ability ||=  if current_admin.present?
                            Ability.new(current_admin)
                          elsif current_expert.present?
                            Ability.new(current_expert)
                          else
                            Ability.new(current_user)
                          end
  end

  protected

  def auth_user
    if current_admin.present?
      authenticate_admin
    elsif current_expert.present?
      authenticate_expert
    else
      authenticate_user
    end
  end

  def init_redis
    @redis = Redis.new(host: 'redis', port: 6379, db: 15)
    @redis.set('temp_users_push_tokens', []) if @redis.get('temp_users_push_tokens').nil?
  end
end
