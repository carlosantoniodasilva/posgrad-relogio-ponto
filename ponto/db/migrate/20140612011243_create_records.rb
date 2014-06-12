class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.references :employee, index: true, null: false
      t.foreign_key :employees, dependent: :delete

      t.date :date, null: false
      t.time :time, null: false

      t.timestamps
    end
  end
end
