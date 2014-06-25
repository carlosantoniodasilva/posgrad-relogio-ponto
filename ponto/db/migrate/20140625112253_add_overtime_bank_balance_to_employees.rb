class AddOvertimeBankBalanceToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :overtime_bank_balance, :decimal, null: false, default: 0
  end
end
