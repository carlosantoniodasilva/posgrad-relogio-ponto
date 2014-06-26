require 'test_helper'

class RecordInconsistencyTest < ActiveSupport::TestCase
  test 'record is required' do
    inconsistency = RecordInconsistency.new(record_id: nil)
    assert_not inconsistency.valid?
    assert_not_empty inconsistency.errors[:record_id]
  end

  test 'kind must be valid' do
    inconsistency = RecordInconsistency.new(kind: nil)
    inconsistency.valid?
    assert_not_empty inconsistency.errors[:kind]

    inconsistency.kind = 'invalid'
    inconsistency.valid?
    assert_not_empty inconsistency.errors[:kind]

    inconsistency.kind = 'feriado'
    inconsistency.valid?
    assert_empty inconsistency.errors[:kind]
  end

  test 'status must be valid' do
    inconsistency = RecordInconsistency.new(kind: nil)
    inconsistency.valid?
    assert_not_empty inconsistency.errors[:kind]

    inconsistency.kind = 'invalid'
    inconsistency.valid?
    assert_not_empty inconsistency.errors[:kind]

    inconsistency.kind = 'feriado'
    inconsistency.valid?
    assert_empty inconsistency.errors[:kind]
  end
end
