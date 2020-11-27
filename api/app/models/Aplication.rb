class Application < ApplicationRecord
  
  validates :email, presence: true, uniqueness: { case_sensitive: true }
  has_secure_password


  def self.from_token_request(request)
    email = request.params&.[]('auth')&.[]('email')
    find_by email: email
  end

  def admin?
    false
  end
end
