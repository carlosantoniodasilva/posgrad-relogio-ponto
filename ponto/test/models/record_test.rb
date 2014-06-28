require 'test_helper'

class RecordTest < ActiveSupport::TestCase
  test 'employee is required' do
    record = Record.new(employee_id: nil)
    assert_not record.valid?
    assert_not_empty record.errors[:employee_id]
  end

  test 'date is required' do
    record = Record.new(date: nil)
    assert_not record.valid?
    assert_not_empty record.errors[:date]
  end
end
