class Department < ActiveRecord::Base
  has_many :employees, dependent: :restrict_with_error
  belongs_to :leader, class_name: 'Employee', inverse_of: :led_departments

  validates :name, presence: true

  to_param :name
end
