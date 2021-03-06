class APIBaseController < ActionController::API
  before_action :init_redis
  include Knock::Authenticable

  def current_ability
    @current_ability ||=  if current_admin.present?
                            Ability.new(current_admin)
                          else
                            Ability.new(current_user)
                          end
  end

  protected

  def auth_user
    if current_admin.present?
      authenticate_admin
    else
      authenticate_user
    end
  end

  def init_redis
    @redis = Redis.new(host: 'redis', port: 6379, db: 15)
    @redis.set('temp_uniq_rate', 0) if @redis.get('temp_uniq_rate').nil?
  end
end
