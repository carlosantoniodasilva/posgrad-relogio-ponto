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

  test 'destroy_updating_employee_balance removes the records and updates employee overtime bank balance' do
    overtime_bank_payment = overtime_bank_payments(:fabricio)
    assert overtime_bank_payment.destroy_updating_employee_balance
    assert_equal 18.75, employees(:fabricio).overtime_bank_balance
  end

  test 'save_updating_employee_balance removes the records and updates employee overtime bank balance' do
    overtime_bank_payment = OvertimeBankPayment.new(employee: employees(:ademar), paid_time: 1)
    assert overtime_bank_payment.save_updating_employee_balance
    assert_equal 0.5, employees(:ademar).overtime_bank_balance
  end
end
