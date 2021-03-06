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
    application = Application.find(chat.application.id)

    p popularity = ((application.count_likes) / (chat.messages.pluck(:sender_id).uniq.count + 1)) * 100
    popularity = 100 if popularity > 100
    
    return if type_message != 1 && content.blank?

    return unless MESSAGE_TYPES.include?(type_message)
    

    new_message = Message.new(content: content, sender: current_user, sender_name: "#{current_user.second_name} #{current_user.surname.at(0)}.#{current_user.name.at(0)}", chat_id: chat_id, picture: picture, type_message: type_message)
    current_user.update(count_messages: current_user.messages.count)
    p application.update(popularity: popularity)
    return unless new_message.save

    ActionCable.server.broadcast room_id, message: new_message.content, picture: new_message.picture, type_message: new_message.type_message, sender_type: new_message.sender_type, sender_id: new_message.sender_id, sender_name: new_message.sender_name, created_at: new_message.created_at
   
  end

  protected

  def room_id
    "room_channel_#{chat_id}"
  end

  def chat_id
    params['chat_id']
  end
end
