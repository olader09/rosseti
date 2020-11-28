class AddFieldToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :start_working, :date
    add_column :users, :birthday, :date
    add_column :users, :education, :string, default: ""
    add_column :users, :count_messages, :integer, default: 0
    add_column :users, :count_approved, :integer, default: 0
  end
end
