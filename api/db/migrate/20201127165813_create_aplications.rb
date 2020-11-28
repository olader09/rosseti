class CreateAplications < ActiveRecord::Migration[5.1]
  def change
    create_table :aplications do |t|
      t.belongs_to :user, class_name: "user", foreign_key: "user_id"
      t.string :title, null: false
      t.text :text, null: false
      t.integer :rating, default: 0
      t.timestamps      
    end
  end
end
