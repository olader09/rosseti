class Application < ApplicationRecord
  after_create :init_chat

  has_one :chat, dependent: :destroy
  belongs_to :user, class_name: "user", foreign_key: "user_id"

  def as_json(_options = {})
    {
      id: id,
      title: title,
      text: text,
      updated_at: updated_at,
      chat_id: chat.id,
      count_likes: 0
    }
  end

  private

  def init_chat
    Chat.create(application_id: id)
  end
end
