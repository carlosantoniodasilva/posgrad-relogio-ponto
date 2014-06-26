require 'json'
require 'net/http'
require 'uri'

class RecordImporter
  class Connection
    ENDPOINT = 'http://cartaopontoserver.azurewebsites.net/api/registrohora'
    Error = Class.new(StandardError)

    def get_records
      response = Net::HTTP.get(URI(ENDPOINT))
      JSON.parse response
    rescue Net::HTTPExceptions => exception
      raise Error.new exception
    end
  end

  class EmployeeNotFound < StandardError
    attr_reader :employee_id

    def initialize(employee_id)
      @employee_id = employee_id
      super "Employee with #{employee_id} was not found."
    end
  end

  class ParseError < StandardError
  end

  cattr_accessor :connection
  self.connection = Connection.new

  def initialize
    @employees = {}
  end

  def import!
    records_to_import = self.class.connection.get_records

    if records_to_import.any?
      transaction do
        group = create_group

        group_record_times(records_to_import) do |employee_id, date, times|
          create_record group, employee_id, date, times
        end

        group
      end
    end
  end

  private

  def create_group
    RecordGroup.create!
  end

  def create_record(group, employee_id, date, times)
    group.records.create!(
      employee: find_employee(employee_id),
      date: parse_date(date),
      times: times
    )
  end

  def find_employee(id)
    @employees[id] ||= Employee.find_by_id(id) || raise(EmployeeNotFound.new(id))
  end

  def group_record_times(records_to_import)
    employee_grouped_records = records_to_import.group_by { |records|
      records['Funcionario']['Id']
    }

    employee_grouped_records.each do |employee_id, employee_records|
      grouped_dates = employee_records.group_by { |records|
        records['DataRegistro']
      }

      grouped_dates.each do |date, records|
        times = records.map { |record| record['HoraRegistro'] }

        yield employee_id, date, times
      end
    end
  end

  def parse_date(date)
    Date.strptime(date, '%m/%d/%Y')
  end

  def transaction
    ActiveRecord::Base.transaction do
      begin
        yield
      rescue ArgumentError, ActiveRecord::RecordInvalid => e
        raise ParseError.new(e)
      end
    end
  end
end
