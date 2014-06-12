require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'role must be valid' do
    user = users(:carlos)

    user.role = nil
    assert_not user.valid?
    assert_not_empty user.errors[:role]

    user.role = 'invalid'
    assert_not user.valid?
    assert_not_empty user.errors[:role]

    user.role = 'hr'
    assert user.valid?
  end
end
