class CreateOvertimeBankPayments < ActiveRecord::Migration
  def change
    create_table :overtime_bank_payments do |t|
      t.references :employee, index: true, null: false
      t.foreign_key :employees, dependent: :delete
      t.decimal :paid_time, null: false

      t.timestamps
    end
  end
end
