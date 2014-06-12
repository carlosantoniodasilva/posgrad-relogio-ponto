class CreateRecordGroups < ActiveRecord::Migration
  def change
    create_table :record_groups do |t|
      t.timestamps
    end
  end
end
