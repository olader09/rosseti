class Application < ApplicationRecord
  after_create :init_chat

  has_one :chat, dependent: :destroy
  belongs_to :user

  def as_json(_options = {})
    {
      id: id,
      title: title,
      problem: problem,
      decision: decision,
      economy: economy,
      other_authors: other_authors,
      expenses: expenses,
      stages: stages,
      file: file,
      doc_app: doc_app,
      count_likes: 0,
      created_at: created_at,
      updated_at: updatede_at,
      chat: {
        id: chat.id
      }
    }
  end

  private

  def init_chat
    Chat.create(application_id: id)
  end
end
