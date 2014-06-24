require 'test_helper'

class HolidayImporterTest < ActiveSupport::TestCase
  test 'requires file' do
    importer = HolidayImporter.new(file: nil)
    assert_not importer.valid?
    assert_not_empty importer.errors[:file]
  end

  test 'import valid holiday csv files' do
    importer = new_importer('holidays/valid')

    holidays = []
    assert_difference 'Holiday.count', 2 do
      holidays = importer.import!
    end

    assert_equal 2, holidays.size
    assert holidays.all?(&:persisted?)

    holiday = holidays[0]
    assert_equal Date.new(2014, 5, 1), holiday.date
    assert_equal 'Dia do Trabalho', holiday.name

    holiday = holidays[1]
    assert_equal Date.new(2014, 10, 12), holiday.date
    assert_equal 'Dia de Nossa Senhora Aparecida', holiday.name

    assert_equal 2, importer.total_created
    assert_equal 0, importer.total_updated
  end

  test 'updates existing holidays names' do
    holidays(:corpus_christi).update_attribute :date, '2014-05-01'

    importer = new_importer('holidays/valid')

    holidays = []
    assert_difference 'Holiday.count', 1 do
      holidays = importer.import!
    end

    assert_equal 2, holidays.size
    assert holidays.all?(&:persisted?)

    holiday = holidays[0]
    assert_equal Date.new(2014, 5, 1), holiday.date
    assert_equal 'Dia do Trabalho', holiday.name
    assert_equal holidays(:corpus_christi).id, holiday.id

    holiday = holidays[1]
    assert_equal Date.new(2014, 10, 12), holiday.date
    assert_equal 'Dia de Nossa Senhora Aparecida', holiday.name

    assert_equal 1, importer.total_created
    assert_equal 1, importer.total_updated
  end

  test 'do not accept files with content type other than text/csv' do
    importer = new_importer('holidays/valid', 'text/other')

    assert_no_difference 'Holiday.count' do
      importer.import!
    end
    assert_not_empty importer.errors[:file]
  end

  test 'ignores entire file in case of errors/inconsistencies and raises parse error' do
    %w(invalid_date invalid_name).each do |file|
      importer = new_importer("holidays/#{file}")
      error_message = "File: #{file}"

      assert_no_difference 'Holiday.count', error_message do
        assert_raise HolidayImporter::ParseError, error_message do
          importer.import!
        end
      end
      assert_equal 0, importer.total_created
      assert_equal 0, importer.total_updated
    end
  end

  private

  def new_importer(file_name, content_type = 'text/csv')
    HolidayImporter.new(file: new_uploaded_file(file_name, content_type))
  end

  def new_uploaded_file(file_name, content_type = 'text/csv')
    ActionDispatch::Http::UploadedFile.new(
      filename: file_name,
      tempfile: open_file(file_name),
      type: content_type
    )
  end

  def open_file(file_name)
    path = file_path(file_name)
    File.open(path) if File.exist?(path)
  end

  def file_path(file_name)
    fixture_path + file_name + '.csv'
  end
end
