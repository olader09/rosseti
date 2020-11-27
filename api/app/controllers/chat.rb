class Chat < ApplicationRecord
  belongs_to :user
  has_many :messages, dependent: :destroy

  def last_message
    messages.last
  end

  def as_json(_options = {})
    {
      id: id,
      updated_at: updated_at,
      user: {
        user_id: user.id,
        name: user.name,
        phone_number: user.phone_number,
        online: user.online,
        verify: user.verify
      },
      last_message: last_message.as_json
    }
  end
end
