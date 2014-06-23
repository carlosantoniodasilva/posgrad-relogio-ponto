class Holiday < ActiveRecord::Base
  validates :name, presence: true
  validates :date, presence: true, uniqueness: { allow_blank: true }

  to_param :name
end
