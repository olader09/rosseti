class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
    t.text :content
    t.references :sender, polymorphic: true, index: true
    t.bigint :chat_id
    t.string :picture
    t.index :chat_id
    t.integer :type_message
    t.timestamps
    end
  end
end
