require 'json'
require 'net/http'
require 'uri'

# TODO: Better error handling for employee not found or connection error.
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

        records_to_import.each do |record_data|
          create_record group, record_data
        end

        group
      end
    end
  end

  private

  def create_group
    RecordGroup.create!
  end

  def create_record(group, record_data)
    group.records.create!(
      employee: find_employee(record_data['Funcionario']['Id']),
      date: record_data['DataRegistro'],
      time: record_data['HoraRegistro']
    )
  end

  def find_employee(id)
    @employees[id] ||= Employee.find_by_id(id) || raise(EmployeeNotFound.new(id))
  end

  def transaction
    ActiveRecord::Base.transaction do
      begin
        yield
      rescue ActiveRecord::RecordInvalid => e
        raise ParseError.new(e)
      end
    end
  end
end
