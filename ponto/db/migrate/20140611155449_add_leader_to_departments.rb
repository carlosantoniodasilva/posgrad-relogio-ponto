class AddLeaderToDepartments < ActiveRecord::Migration
  def change
    add_reference :departments, :leader, index: true
    add_foreign_key :departments, :employees, column: :leader_id
  end
end
