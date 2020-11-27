class Admin < ApplicationRecord
  
  validates :login, presence: true, uniqueness: { case_sensitive: true }
  has_secure_password

  def self.from_token_request(request)
    login = request.params&.[]('auth')&.[]('login')
    find_by login: login
  end


  def admin?
    true
  end
end
