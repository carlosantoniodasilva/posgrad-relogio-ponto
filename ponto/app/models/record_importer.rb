require 'json'
require 'net/http'
require 'uri'

# TODO: Better error handling for employee not found or connection error.
class RecordImporter
  class Connection
    ENDPOINT = 'http://cartaopontoserver.azurewebsites.net/api/registrohora'

    def get_records
      response = Net::HTTP.get(URI(ENDPOINT))
      JSON.parse response
    end
  end

  def initialize(connection = Connection.new)
    @connection = connection
    @employees = {}
  end

  def import!
    records_to_import = @connection.get_records

    if records_to_import.any?
      ActiveRecord::Base.transaction do
        group = create_group

        records_to_import.each do |record_data|
          create_record group, record_data
        end
      end
    end

    records_to_import.size
  end

  private

  def create_group
    RecordGroup.create!
  end

  def create_record(group, record_data)
    group.records.create!(
      employee: find_employee(record_data['Id']),
      date: record_data['DataRegistro'],
      time: record_data['HoraRegistro']
    )
  end

  def find_employee(id)
    @employees[id] ||= Employee.find(id)
  end
end
