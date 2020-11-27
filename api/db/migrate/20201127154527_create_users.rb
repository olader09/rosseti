class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :surname
      t.string :second_name
      t.string :password_digest
      t.float :rating, default: 0
      t.string :unit, null: false
      t.string :email, null: false
      t.string :push_token
      t.timestamps
    end
  end
end
