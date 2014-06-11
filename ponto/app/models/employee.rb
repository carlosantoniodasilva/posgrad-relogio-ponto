class Employee < ActiveRecord::Base
  belongs_to :department
  has_many :led_departments, class_name: 'Department',
    foreign_key: :leader_id, inverse_of: :leader

  validates :name, :department_id, presence: true

  to_param :name
end
