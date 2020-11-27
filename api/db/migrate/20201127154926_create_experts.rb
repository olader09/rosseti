class CreateExperts < ActiveRecord::Migration[5.1]
  def change
    create_table :experts do |t|
      t.string :name
      t.string :password_digest
      t.string :email, null: false
      t.string :unit, null: false
      t.string :push_token
      t.timestamps
    end
  end
end
