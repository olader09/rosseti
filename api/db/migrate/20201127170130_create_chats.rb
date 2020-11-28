class CreateChats < ActiveRecord::Migration[5.1]
  def change
    create_table :chats do |t|
      t.bigint :application_id, null: false
      t.index :application_id
    end
  end
end
