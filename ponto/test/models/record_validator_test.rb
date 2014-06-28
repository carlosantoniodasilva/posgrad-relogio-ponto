require 'test_helper'

class RecordValidatorTest < ActiveSupport::TestCase
  setup do
    @group = RecordGroup.create!
  end

  def create_records(employees, date, times = %w(08:00 12:02 13:00 17:00))
    employees.map do |employee|
      @group.records.create! employee: employee, date: date, times: times
    end
  end

  def validator(group = @group)
    RecordValidator.new(group)
  end

  test 'generates no inconsistencies when contains valid 4 records in the day' do
    create_records Employee.all, Date.new(2014, 6, 11)

    assert_no_difference 'RecordInconsistency.count' do
      validator.validate!
    end
  end

  test 'generates no inconsistencies for missing records on weekends' do
    employees = Employee.all.to_a
    create_records employees, Date.new(2014, 6, 13)
    create_records employees, Date.new(2014, 6, 16)

    assert_no_difference 'RecordInconsistency.count' do
      validator.validate!
    end
  end

  test 'generates no inconsistencies for missing records on holidays' do
    employees = Employee.all.to_a
    create_records employees, holidays(:corpus_christi).date - 1.day
    create_records employees, holidays(:corpus_christi).date + 1.day

    assert_no_difference 'RecordInconsistency.count' do
      validator.validate!
    end
  end

  test 'generates an inconsistency for less than 4 records in the day' do
    employees = Employee.all.to_a
    records = create_records [employees.shift], Date.new(2014, 6, 11), %w(08:00 12:00 13:00)
    create_records employees, Date.new(2014, 6, 11)

    assert_difference 'RecordInconsistency.count', 1 do
      validator.validate!
    end

    assert_equal 'below_limit', records.first.inconsistency.kind
    assert_equal 'pending', records.first.inconsistency.status
  end

  test 'generates an inconsistency for more than 4 records in the day' do
    employees = Employee.all.to_a
    records = create_records [employees.shift], Date.new(2014, 6, 11), %w(08:00 12:00 13:00 17:00 18:00 20:00)
    create_records employees, Date.new(2014, 6, 11)

    assert_difference 'RecordInconsistency.count', 1 do
      validator.validate!
    end

    assert_equal 'above_limit', records.first.inconsistency.kind
    assert_equal 'pending', records.first.inconsistency.status
  end

  test 'generates an inconsistency for missing records in a work day' do
    employees = Employee.all.to_a
    create_records employees, Date.new(2014, 6, 10)
    create_records employees.last(employees.size - 1), Date.new(2014, 6, 11)
    create_records employees, Date.new(2014, 6, 12)

    assert_difference 'Record.count', 1 do
      assert_difference 'RecordInconsistency.count', 1 do
        validator.validate!
      end
    end

    record = Record.last
    assert_equal employees.first, record.employee
    assert_equal Date.new(2014, 6, 11), record.date
    assert_equal 'missing', record.inconsistency.kind
    assert_equal 'pending', record.inconsistency.status
  end

  test 'generates an inconsistency for any records on weekends' do
    records = create_records [Employee.first], Date.new(2014, 6, 14)

    assert_difference 'RecordInconsistency.count', 1 do
      validator.validate!
    end

    assert_equal 'weekend', records.first.inconsistency.kind
    assert_equal 'pending', records.first.inconsistency.status
  end

  test 'generates an inconsistency for any records on holidays' do
    records = create_records [Employee.first], holidays(:corpus_christi).date

    assert_difference 'RecordInconsistency.count', 1 do
      validator.validate!
    end

    assert_equal 'holiday', records.first.inconsistency.kind
    assert_equal 'pending', records.first.inconsistency.status
  end
end
