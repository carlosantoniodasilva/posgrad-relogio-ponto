class RecordValidator
  TIMES_LIMIT = 4

  attr_reader :record_group, :records, :min_date, :max_date, :employees

  def initialize(record_group, employees = Employee.all)
    @record_group = record_group
    @records = record_group.records
    @min_date, @max_date = @records.map(&:date).minmax
    @employees = employees
  end

  def validate!
    grouped_records = records.group_by(&:date)

    (min_date..max_date).each do |date|
      validate_records date, grouped_records.fetch(date, [])
    end
  end

  private

  def create_inconsistencies(records, kind)
    records.each { |record| create_inconsistency record, kind }
  end

  def create_inconsistency(record, kind)
    record.create_inconsistency!(kind: kind, status: :pending)
  end

  def create_record_with_inconsistency(employee, date, kind)
    record = record_group.records.create! employee: employee, date: date
    create_inconsistency record, kind
  end

  def validate_limits(records)
    records.each do |record|
      if above_limit?(record.times)
        create_inconsistency record, :above_limit
      elsif below_limit?(record.times)
        create_inconsistency record, :below_limit
      end
    end
  end

  def validate_missing(date, records)
    missing_employees = employees - records.map(&:employee)
    missing_employees.each do |employee|
      create_record_with_inconsistency employee, date, :missing
    end
  end

  def validate_records(date, date_records)
    if weekend?(date)
      create_inconsistencies date_records, :weekend if date_records.any?
    elsif holiday?(date)
      create_inconsistencies date_records, :holiday if date_records.any?
    else
      validate_missing date, date_records
      validate_limits date_records
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

  def workday?(date)
    !weekend?(date)
  end
end
