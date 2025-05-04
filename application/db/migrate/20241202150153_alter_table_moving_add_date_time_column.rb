class AlterTableMovingAddDateTimeColumn < ActiveRecord::Migration[5.1]
    def change
      add_column :movings, :presence_time, :datetime, null: true
      add_column :movings, :presence_2_time, :datetime, null: true
      add_column :movings, :presence_3_time, :datetime, null: true
      add_column :movings, :presence_4_time, :datetime, null: true
      add_column :movings, :presence_5_time, :datetime, null: true
      add_column :movings, :presence_6_time, :datetime, null: true
      add_column :movings, :presence_7_time, :datetime, null: true
      add_column :movings, :presence_8_time, :datetime, null: true
      add_column :movings, :presence_9_time, :datetime, null: true
      add_column :movings, :presence_10_time, :datetime, null: true
    end
  end
  