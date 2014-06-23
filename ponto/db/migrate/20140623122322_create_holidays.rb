class CreateHolidays < ActiveRecord::Migration
  def change
    create_table :holidays do |t|
      t.date :date, null: false
      t.index :date, unique: true

      t.string :name, null: false

      t.timestamps
    end
  end
end
