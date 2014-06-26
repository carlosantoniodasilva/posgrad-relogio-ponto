class ChangeRecordTimeToArray < ActiveRecord::Migration
  def up
    remove_column :records, :time
    add_column :records, :times, :time, array: true, null: false, default: []
  end

  def down
    remove_column :records, :times
    add_column :records, :time, :time, null: false
  end
end
