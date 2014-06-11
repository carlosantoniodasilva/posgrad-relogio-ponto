class Employee < ActiveRecord::Base
  belongs_to :department
  validates :name, :department_id, presence: true

  to_param :name
end
