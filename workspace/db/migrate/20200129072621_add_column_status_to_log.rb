class AddColumnStatusToLog < ActiveRecord::Migration[5.1]
  def change
    add_column :logs, :status, :boolean, default: :true
  end
end
