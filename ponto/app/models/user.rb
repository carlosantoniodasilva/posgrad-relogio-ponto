class User < ActiveRecord::Base
  belongs_to :employee

  devise :database_authenticatable, :validatable

  ROLES = %w(admin hr leader)
  validates :role, presence: true, inclusion: { in: ROLES, allow_blank: true }
end
