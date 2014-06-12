class RecordGroup < ActiveRecord::Base
  has_many :records, foreign_key: :group_id
end
