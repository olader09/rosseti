class User < ApplicationRecord

  validates :email, presence: true, uniqueness: { case_sensitive: true }
  has_secure_password

  has_one :chat, dependent: :destroy
  has_many :messages, -> { where(sender_type: 'User') }, foreign_key: :sender_id

  def to_token_payload
    {
      sub: id,
      class: self.class.to_s
    }
  end

  def self.from_token_request(request)
    email = request.params&.[]('auth')&.[]('email')
    find_by email: email
  end

  def self.from_token_payload(payload)
    find(payload['sub']) if payload['sub'] && payload['class'] && payload['class'] == to_s
  end

  def admin?
    false
  end

  def banned?
    banned
  end
end
