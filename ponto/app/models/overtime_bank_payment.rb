class OvertimeBankPayment < ActiveRecord::Base
  belongs_to :employee

  validates :employee_id, presence: true
  validates :paid_time, presence: true, numericality: {
    greater_than: 0.0, less_than_or_equal_to: :employee_overtime_bank_balance, allow_blank: true }

  private

  def employee_overtime_bank_balance
    employee ? employee.overtime_bank_balance : 0
  end
end
