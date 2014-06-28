class AddOvertimeBankToRecords < ActiveRecord::Migration
  def change
    add_column :records, :overtime_bank, :decimal, null: false, default: 0
  end
end
