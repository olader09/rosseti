class Application < ApplicationRecord
  after_create :init_chat

  has_one :chat, dependent: :destroy
  belongs_to :user, class_name: "user", foreign_key: "user_id"

  private

  def init_chat
    Chat.create(application_id: id)
  end
end
