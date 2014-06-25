require 'test_helper'

class DepartmentTest < ActiveSupport::TestCase
  test 'name is required' do
    department = Department.new(name: nil)
    assert_not department.valid?
    assert_not_empty department.errors[:name]
  end
end
