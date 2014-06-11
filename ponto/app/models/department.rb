class Department < ActiveRecord::Base
  validates :name, presence: true

  to_param :name
end
