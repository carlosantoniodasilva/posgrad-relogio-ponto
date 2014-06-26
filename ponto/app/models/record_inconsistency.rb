class RecordInconsistency < ActiveRecord::Base
  belongs_to :record

  enum kind: %i[missing above_limit below_limit weekend holiday]
  enum status: %i[pending granted verified]

  validates :record_id, presence: true
  validates :kind, presence: true, inclusion: { in: kinds.keys, allow_blank: true }
  validates :status, presence: true, inclusion: { in: statuses.keys, allow_blank: true }
end
