class Department < ActiveRecord::Base
  has_many :employees, dependent: :restrict_with_error
  belongs_to :leader, class_name: 'Employee', inverse_of: :led_departments

  scope :with_overtime_bank_balance, -> {
    select(%q[
      departments.*,
      (
        select sum(overtime_bank_balance)
        from employees
        where department_id = departments.id
      ) as overtime_bank_balance
    ])
  }

  validates :name, presence: true

  to_param :name

  def overtime_bank_balance
    self[:overtime_bank_balance] || 0.0
  end
end
