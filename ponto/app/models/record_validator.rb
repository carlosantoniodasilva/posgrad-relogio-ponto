class RecordValidator
  TIMES_LIMIT = 4

  attr_reader :records

  def initialize(records)
    @records = records
  end

  def validate!
    records.each do |record|
      validate_record record
    end
  end

  private

  def create_inconsistency(record, kind)
    record.create_inconsistency!(kind: kind, status: 'pendente')
  end

  def validate_record(record)
    if above_limit?(record.times)
      create_inconsistency record, 'mais_registros'
    elsif below_limit?(record.times)
      create_inconsistency record, 'menos_registros'
    elsif weekend?(record.date)
      create_inconsistency record, 'final_semana'
    elsif holiday?(record.date)
      create_inconsistency record, 'feriado'
    end
  end

  def above_limit?(times)
    times.size > TIMES_LIMIT
  end

  def below_limit?(times)
    times.size < TIMES_LIMIT
  end

  def holiday?(date)
    Holiday.where(date: date).exists?
  end

  def weekend?(date)
    date.saturday? || date.sunday?
  end
end
