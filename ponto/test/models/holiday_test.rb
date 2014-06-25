require 'test_helper'

class HolidayTest < ActiveSupport::TestCase
  test 'date is required' do
    holiday = Holiday.new(date: nil)
    assert_not holiday.valid?
    assert_not_empty holiday.errors[:date]
  end

  test 'date must be unique' do
    holiday = holidays(:independencia).dup
    assert_not holiday.valid?
    assert_not_empty holiday.errors[:date]
  end

  test 'name is required' do
    holiday = Holiday.new(name: nil)
    assert_not holiday.valid?
    assert_not_empty holiday.errors[:name]
  end
end
