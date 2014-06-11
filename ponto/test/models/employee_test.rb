require 'test_helper'

class EmployeeTest < ActiveSupport::TestCase
  test 'name is required' do
    employee = Employee.new
    assert_not employee.valid?
    assert_not_empty employee.errors[:name]
  end

  test 'department is required' do
    employee = Employee.new
    assert_not employee.valid?
    assert_not_empty employee.errors[:department_id]
  end
end
