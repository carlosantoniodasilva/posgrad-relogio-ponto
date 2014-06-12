class AddEmployeeToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :employee, index: true, null: false
    add_foreign_key :users, :employees, dependent: :delete
  end
end
