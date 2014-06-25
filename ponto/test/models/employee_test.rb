require 'test_helper'

class EmployeeTest < ActiveSupport::TestCase
  test 'name is required' do
    employee = Employee.new(name: nil)
    assert_not employee.valid?
    assert_not_empty employee.errors[:name]
  end

  test 'department is required' do
    employee = Employee.new(department_id: nil)
    assert_not employee.valid?
    assert_not_empty employee.errors[:department_id]
  end

  test 'overtime_bank_balance is required' do
    employee = Employee.new(overtime_bank_balance: nil)
    assert_not employee.valid?
    assert_not_empty employee.errors[:overtime_bank_balance]
  end
end
