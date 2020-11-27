class CreateChats < ActiveRecord::Migration[5.1]
  def change
    create_table :chats do |t|
      t.bigint :user_id, null: false
      t.index :user_id
    end
  end
end
