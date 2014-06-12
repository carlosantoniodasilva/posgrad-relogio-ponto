require 'test_helper'

class RecordImporterTest < ActiveSupport::TestCase
  class FakeConnection
    def initialize(records)
      @records = records
    end

    def get_records
      @records
    end
  end

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
    importer = RecordImporter.new(FakeConnection.new(records))

    assert_difference 'RecordGroup.count', 1 do
      assert_difference 'Record.count', 7 do
        assert_equal 7, importer.import!
      end
    end
  end

  test 'imports nothing when there is no record available' do
    importer = RecordImporter.new(FakeConnection.new([]))

    assert_no_difference 'RecordGroup.count', 'Record.count' do
      assert_equal 0, importer.import!
    end
  end

  test 'raises when there is an invalid employee' do
    records = [
      { 'Id' => employees(:fabricio).id, 'DataRegistro' => '10/06/2014', 'HoraRegistro' => '08:05:23' },
      { 'Id' => employees(:nilson).id,   'DataRegistro' => '11/06/2014', 'HoraRegistro' => '07:58:43' },
      { 'Id' => 99,                      'DataRegistro' => '11/06/2014', 'HoraRegistro' => '17:05:00' }
    ]
    importer = RecordImporter.new(FakeConnection.new(records))

    assert_no_difference 'RecordGroup.count', 'Record.count' do
      assert_raise ActiveRecord::RecordNotFound do
        assert_equal 0, importer.import!
      end
    end
  end
end
