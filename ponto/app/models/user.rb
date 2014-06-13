class User < ActiveRecord::Base
  belongs_to :employee
  has_many :led_departments, through: :employee
  has_many :led_employees, through: :led_departments, source: :employees

  devise :database_authenticatable, :validatable

  ROLES = %w(admin hr leader).each do |role|
    define_method("#{role}?") { self.role == role }
  end
  validates :role, presence: true, inclusion: { in: ROLES, allow_blank: true }
end
