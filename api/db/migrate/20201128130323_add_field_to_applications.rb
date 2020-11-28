class AddFieldToApplications < ActiveRecord::Migration[5.1]
  def change
    add_column :applications, :category, :string, default: ""
    add_column :applications, :problem, :string, default: ""
    add_column :applications, :decision, :string, default: ""
    add_column :applications, :impact, :string, default: ""
    add_column :applications, :economy, :boolean, default: false
    add_column :applications, :other_authors, :jsonb
    add_column :applications, :expenses, :jsonb
    add_column :applications, :stages, :jsonb
    add_column :applications, :file, :string
    add_column :applications, :doc_app, :string
    remove_column :applications, :text

    
  end
end
