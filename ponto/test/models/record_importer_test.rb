require 'test_helper'
require 'support/record_importer'

class RecordImporterTest < ActiveSupport::TestCase
  include Support::RecordImporter

  test 'imports all records and groups them in a single group record' do
    records = [
      { 'Id' => employees(:fabricio).id, 'DataRegistro' => '10/06/2014', 'HoraRegistro' => '08:05:23' },
      { 'Id' => employees(:fabricio).id, 'DataRegistro' => '10/06/2014', 'HoraRegistro' => '12:00:04' },
      { 'Id' => employees(:fabricio).id, 'DataRegistro' => '10/06/2014', 'HoraRegistro' => '13:05:18' },
      { 'Id' => employees(:fabricio).id, 'DataRegistro' => '10/06/2014', 'HoraRegistro' => '16:58:02' },
      { 'Id' => employees(:nilson).id,   'DataRegistro' => '11/06/2014', 'HoraRegistro' => '07:58:43' },
      { 'Id' => employees(:nilson).id,   'DataRegistro' => '11/06/2014', 'HoraRegistro' => '12:02:53' },
      { 'Id' => employees(:nilson).id,   'DataRegistro' => '11/06/2014', 'HoraRegistro' => '17:05:00' }
    ]

    stub_record_importer_connection records do |importer|
      importer = RecordImporter.new

      assert_difference 'RecordGroup.count', 1 do
        assert_difference 'Record.count', 7 do
          group = importer.import!
          assert_equal 7, group.records.size
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
    records = [
      { 'Id' => employees(:fabricio).id, 'DataRegistro' => '10/06/2014', 'HoraRegistro' => '08:05:23' },
      { 'Id' => employees(:nilson).id,   'DataRegistro' => '11/06/2014', 'HoraRegistro' => '07:58:43' },
      { 'Id' => 99,                      'DataRegistro' => '11/06/2014', 'HoraRegistro' => '17:05:00' }
    ]

    stub_record_importer_connection records do
      importer = RecordImporter.new

      assert_no_difference 'RecordGroup.count', 'Record.count' do
        assert_raise RecordImporter::EmployeeNotFound do
          importer.import!
        end
      end
    end
  end
end
