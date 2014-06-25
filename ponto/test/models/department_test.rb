require 'test_helper'

class DepartmentTest < ActiveSupport::TestCase
  test 'name is required' do
    department = Department.new(name: nil)
    assert_not department.valid?
    assert_not_empty department.errors[:name]
  end

  test 'calculates overtime bank balance based on employees' do
    department = departments(:financial)
    assert_equal 0, department.overtime_bank_balance

    department = Department.with_overtime_bank_balance.find(department)
    assert_equal 1.5, department.overtime_bank_balance
  end
end
