class AddColumnCountLikesToApplications < ActiveRecord::Migration[5.1]
  def change
    add_column :applications, :count_likes, :integer, default: 0
  end
end
