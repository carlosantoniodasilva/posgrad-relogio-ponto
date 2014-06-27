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

    inconsistency.kind = 'weekend'
    inconsistency.valid?
    assert_empty inconsistency.errors[:kind]
  end

  test 'status must be valid' do
    inconsistency = RecordInconsistency.new(status: nil)
    inconsistency.valid?
    assert_not_empty inconsistency.errors[:status]

    inconsistency.status = 'granted'
    inconsistency.valid?
    assert_empty inconsistency.errors[:status]
  end

  test 'notes must be present when marking as granted/verified' do
    inconsistency = RecordInconsistency.new(notes: nil)
    inconsistency.valid?
    assert_empty inconsistency.errors[:notes]

    inconsistency.status = 'pending'
    inconsistency.valid?
    assert_empty inconsistency.errors[:notes]

    inconsistency.status = 'granted'
    inconsistency.valid?
    assert_not_empty inconsistency.errors[:notes]

    inconsistency.status = 'verified'
    inconsistency.valid?
    assert_not_empty inconsistency.errors[:notes]
  end
end
