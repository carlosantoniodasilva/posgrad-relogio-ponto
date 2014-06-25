require 'test_helper'
require 'support/record_importer'

class RecordImporterTest < ActiveSupport::TestCase
  include Support::RecordImporter

  test 'imports all records and groups them in a single group record' do
    stub_record_importer_connection test_records do |importer|
      importer = RecordImporter.new

      assert_difference 'RecordGroup.count', 1 do
        assert_difference 'Record.count', 7 do
          group = importer.import!
          assert_equal 7, group.records.size

          record = group.records.first
          assert_equal employees(:fabricio), record.employee
          assert_equal Date.new(2014, 6, 10), record.date
          assert_equal Time.utc(2000, 1, 1, 8, 5, 23), record.time

          record = group.records.last
          assert_equal employees(:nilson), record.employee
          assert_equal Date.new(2014, 6, 11), record.date
          assert_equal Time.utc(2000, 1, 1, 17, 5), record.time
        end
      end
    end
  end

  test 'imports nothing when there is no record available' do
    stub_record_importer_connection [] do
      importer = RecordImporter.new

      assert_no_difference 'RecordGroup.count', 'Record.count' do
        assert_nil importer.import!
      end
    end
  end

  test 'raises when there is an invalid employee' do
    records = test_records.first(3)
    records.last['Funcionario']['Id'] = 99

    stub_record_importer_connection records do
      importer = RecordImporter.new

      assert_no_difference 'RecordGroup.count', 'Record.count' do
        assert_raise RecordImporter::EmployeeNotFound do
          importer.import!
        end
      end
    end
  end

  test 'raises when receiving an invalid or missing date/time' do
    records = test_records.first(3)
    records.last['DataRegistro'] = ''

    stub_record_importer_connection records do
      importer = RecordImporter.new

      assert_no_difference 'RecordGroup.count', 'Record.count' do
        assert_raise RecordImporter::ParseError do
          importer.import!
        end
      end
    end
  end
end
