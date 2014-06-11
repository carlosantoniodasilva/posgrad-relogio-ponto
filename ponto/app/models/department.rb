class Department < ActiveRecord::Base
  has_many :employees, dependent: :restrict_with_error
  validates :name, presence: true

  to_param :name
end
