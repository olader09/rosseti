class AddFieldToUsersPost < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :post, :string, default: ""
  end
end
