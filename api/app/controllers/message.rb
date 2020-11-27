class Message < ApplicationRecord
  after_create :update_time_chat

  belongs_to :sender, polymorphic: true
  belongs_to :chat

  mount_uploader :picture, MessageImageUploader
  mount_base64_uploader :picture, MessageImageUploader

  protected

  def update_time_chat
    chat.update(updated_at: Time.zone.now)
  end
end
