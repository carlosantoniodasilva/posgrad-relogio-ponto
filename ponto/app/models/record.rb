class Record < ActiveRecord::Base
  belongs_to :employee
  belongs_to :group, class_name: 'RecordGroup'
  has_one :inconsistency, class_name: 'RecordInconsistency'

  scope :between, -> from, to {
    where('"date" >= :from AND "date" <= :to', from: from, to: to)
  }

  validates :employee_id, :date, :times, presence: true
end
