class RoomChannel < ApplicationCable::Channel
  MESSAGE_TYPES = [0, 1].freeze

  def subscribed
    stream_from room_id
  end

  def unsubscribed

  end

  def receive(data)
    type_message = data['type_message']
    picture = data['picture']
    content = data['message']
    time_now = Time.zone.now
    chat = Chat.find(chat_id)
    application = chat.application

    popularity = ((chat.messages.pluck(:sender_id).uniq.count) / (application.count_likes + 1) * 100)
    popularity = 100 if popularity > 100
    
    return if type_message != 1 && content.blank?

    return unless MESSAGE_TYPES.include?(type_message)
    

    new_message = Message.new(content: content, sender: current_user, chat_id: chat_id, picture: picture, type_message: type_message)
    current_user.update(count_messages: current_user.messages.count)
    application.update(popularity: popularity)
    return unless new_message.save

    ActionCable.server.broadcast room_id, message: new_message.content, picture: new_message.picture, type_message: new_message.type_message, sender_type: new_message.sender_type, sender_id: new_message.sender_id, created_at: new_message.created_at
   
  end

  protected

  def room_id
    "room_channel_#{chat_id}"
  end

  def chat_id
    params['chat_id']
  end
end
