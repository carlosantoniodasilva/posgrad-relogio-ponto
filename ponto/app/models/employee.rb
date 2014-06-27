class Employee < ActiveRecord::Base
  belongs_to :department
  has_many :led_departments, class_name: 'Department',
    foreign_key: :leader_id, inverse_of: :leader
  has_many :records
  has_many :record_inconsistencies, through: :records, source: :inconsistency
  has_many :overtime_bank_payments
  has_one :user, dependent: :destroy

  validates :name, :department_id, :overtime_bank_balance, presence: true

  to_param :name

  accepts_nested_attributes_for :user, allow_destroy: true, reject_if: :all_blank
end
