class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :name, null: false
      t.references :department, index: true, null: false
      t.foreign_key :departments

      t.timestamps
    end
  end
end
