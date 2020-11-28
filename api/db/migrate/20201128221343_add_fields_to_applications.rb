class AddFieldsToApplications < ActiveRecord::Migration[5.1]
  def change
    add_column :applications, :status, :integer, default: 0
    add_column :applications, :popularity, :integer, default: 0
    add_column :applications, :uniqueness, :integer, default: 0
    add_column :applications, :direction_activity, :integer, default: 0
  end
end
