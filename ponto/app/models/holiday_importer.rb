require 'csv'

# Import holidays from a CSV file
#
# Example file structure (no headers required):
#
#   19/06/2014,Corpus Christi
#   07/09/2014,Independência do Brasil
class HolidayImporter
  ACCEPT_CONTENT_TYPE = 'text/csv'
  ParseError = Class.new(StandardError)

  include ActiveModel::Model

  attr_reader :file, :total_created, :total_updated
  validate :require_valid_uploaded_file

  def import!
    valid? && process!
  end

  private

  def initialize(attributes = {})
    @file = attributes[:file]
    reset_totals
  end

  def process!
    transaction do
      holidays = []

      CSV.foreach(file.tempfile) do |line|
        holidays << process_line(*line)
      end

      holidays
    end
  end

  def process_line(date, name)
    holiday = Holiday.find_or_initialize_by(date: parse_date(date))
    update_totals(holiday)

    holiday.update_attributes!(name: name)
    holiday
  end

  def reset_totals
    @total_created = @total_updated = 0
  end

  def require_valid_uploaded_file
    unless file.respond_to?(:tempfile) &&
      file.respond_to?(:content_type) &&
      file.content_type == ACCEPT_CONTENT_TYPE
      errors.add(:file, :invalid)
    end
  end

  def parse_date(date)
    Date.strptime(date, '%d/%m/%Y')
  end

  def update_totals(holiday)
    if holiday.persisted?
      @total_updated += 1
    else
      @total_created += 1
    end
  end

  def transaction
    Holiday.transaction do
      begin
        yield
      rescue ArgumentError, ActiveRecord::RecordInvalid => e
        reset_totals
        raise ParseError.new(e)
      end
    end
  end
end
