class OvertimeBankPayment < ActiveRecord::Base
  belongs_to :employee

  validates :employee_id, presence: true
  validates :paid_time, presence: true, numericality: {
    greater_than: 0.0, less_than_or_equal_to: :employee_overtime_bank_balance, allow_blank: true }

  def destroy_updating_employee_balance
    transaction do
      destroy && update_employee_balance(+paid_time)
    end
  end

  def save_updating_employee_balance
    transaction do
      save && update_employee_balance(-paid_time)
    end
  end

  private

  def employee_overtime_bank_balance
    employee ? employee.overtime_bank_balance : 0
  end

  def update_employee_balance(adjustment)
    employee.update_column :overtime_bank_balance, employee.overtime_bank_balance + adjustment
  end
end
