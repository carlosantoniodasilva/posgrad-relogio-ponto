class RecordInconsistency < ActiveRecord::Base
  KINDS = %w(falta mais_registros menos_registros final_semana feriado)
  STATUSES = %w(pendente abonado verificado)
  belongs_to :record

  validates :record_id, presence: true
  validates :kind, presence: true, inclusion: { in: KINDS, allow_blank: true }
  validates :status, presence: true, inclusion: { in: STATUSES, allow_blank: true }
end
