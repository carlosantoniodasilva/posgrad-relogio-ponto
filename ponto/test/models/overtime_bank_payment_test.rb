require 'test_helper'

class OvertimeBankPaymentTest < ActiveSupport::TestCase
  test 'employee is required' do
    overtime_bank_payment = OvertimeBankPayment.new(employee_id: nil)
    assert_not overtime_bank_payment.valid?
    assert_not_empty overtime_bank_payment.errors[:employee_id]
  end

  test 'paid_time is required' do
    overtime_bank_payment = OvertimeBankPayment.new(paid_time: nil)
    assert_not overtime_bank_payment.valid?
    assert_not_empty overtime_bank_payment.errors[:paid_time]
  end

  test 'paid_time must be greater than 0' do
    overtime_bank_payment = OvertimeBankPayment.new(paid_time: 0)
    assert_not overtime_bank_payment.valid?
    assert_not_empty overtime_bank_payment.errors[:paid_time]
  end

  test 'paid_time must be smaller than employee\'s overtime bank balance' do
    employee = employees(:ademar)
    overtime_bank_payment = OvertimeBankPayment.new(
      employee: employee, paid_time: employee.overtime_bank_balance + 1)
    assert_not overtime_bank_payment.valid?
    assert_not_empty overtime_bank_payment.errors[:paid_time]
  end
end
