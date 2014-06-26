class CreateRecordInconsistencies < ActiveRecord::Migration
  def change
    create_table :record_inconsistencies do |t|
      t.references :record, index: true, null: false
      t.foreign_key :records, dependent: :delete

      t.string :kind, null: false
      t.string :status, null: false
      t.string :notes

      t.timestamps
    end
  end
end
