class ChangeFieldApplications < ActiveRecord::Migration[5.1]
  def change
    change_column :applications, :status,  :integer, default: 1
  end
end
