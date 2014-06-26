require 'test_helper'

class RecordValidatorTest < ActiveSupport::TestCase
  setup do
    @record = records(:ademar_1)
  end

  test 'generates no inconsistencies when contains valid 4 records in the day' do
    validator = RecordValidator.new([@record])

    assert_no_difference 'RecordInconsistency.count' do
      validator.validate!
    end
  end

  test 'generates no inconsistencies for missing records on weekends' do
    skip 'TODO'
  end

  test 'generates no inconsistencies for missing records on holidays' do
    skip 'TODO'
  end

  test 'generates an inconsistency for less than 4 records in the day' do
    @record.times = ['08:00', '12:00', '13:00']
    validator = RecordValidator.new([@record])

    assert_difference 'RecordInconsistency.count', 1 do
      validator.validate!
    end

    assert_equal 'menos_registros', @record.inconsistency.kind
    assert_equal 'pendente', @record.inconsistency.status
  end

  test 'generates an inconsistency for more than 4 records in the day' do
    @record.times = ['08:00', '12:00', '13:00', '17:00', '18:00', '20:00']
    validator = RecordValidator.new([@record])

    assert_difference 'RecordInconsistency.count', 1 do
      validator.validate!
    end

    assert_equal 'mais_registros', @record.inconsistency.kind
    assert_equal 'pendente', @record.inconsistency.status
  end

  test 'generates an inconsistency for missing records in a work day' do
    skip 'TODO'
  end

  test 'generates an inconsistency for any records on weekends' do
    @record.date = '2014-06-28'
    validator = RecordValidator.new([@record])

    assert_difference 'RecordInconsistency.count', 1 do
      validator.validate!
    end

    assert_equal 'final_semana', @record.inconsistency.kind
    assert_equal 'pendente', @record.inconsistency.status
  end

  test 'generates an inconsistency for any records on holidays' do
    @record.date = holidays(:corpus_christi).date
    validator = RecordValidator.new([@record])

    assert_difference 'RecordInconsistency.count', 1 do
      validator.validate!
    end

    assert_equal 'feriado', @record.inconsistency.kind
    assert_equal 'pendente', @record.inconsistency.status
  end
end
