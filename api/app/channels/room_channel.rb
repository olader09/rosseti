class RoomChannel < ApplicationCable::Channel
  MESSAGE_TYPES = [0, 1].freeze

  def subscribed
    stream_from room_id
    messages_history = Messages.where(chat_id: chat_id)
    ActionCable.server.broadcast room_id, messages: messages_history.to_json
  end

  def unsubscribed

  end

  def receive(data)
    type_message = data['type_message']
    picture = data['picture']
    content = data['message']
    time_now = Time.zone.now
    return if type_message != 0 && content.blank?

    return unless MESSAGE_TYPES.include?(type_message)
    

    new_message = Message.new(content: content, sender: current_user, chat_id: chat_id, picture: picture, type_message: type_message)
    return unless new_message.save

    ActionCable.server.broadcast room_id, message: content, picture: new_message.picture, type_message: type_message, sender_type: new_message.sender_type, created_at: new_message.created_at
   
  end

  protected

  def room_id
    "room_channel_#{chat_id}"
  end

  def chat_id
    params['chat_id']
  end
end
