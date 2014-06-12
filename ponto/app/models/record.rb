class Record < ActiveRecord::Base
  belongs_to :employee

  scope :between, -> from, to {
    where('"date" >= :from AND "date" <= :to', from: from, to: to)
  }

  validates :employee_id, :date, :time, presence: true
end
