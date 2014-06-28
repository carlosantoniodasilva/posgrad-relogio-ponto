require 'test_helper'
require 'support/record_importer'

class RecordImportsTest < ActionDispatch::IntegrationTest
  include Support::RecordImporter

  setup do
    login_as users(:carlos)
  end

  test 'importing records for the first time from the api' do
    RecordGroup.delete_all
    records = test_records
    records = [records.first, records.last]

    stub_record_importer_connection records do
      visit new_record_import_path

      assert_title 'Importar Registros'
      assert_content 'Nenhuma atualização de registros ponto foi efetuada ainda.'

      click_on 'Atualizar'

      assert_flash 'Importação de registros do ponto efetuada com sucesso.'
      assert_content '8 registros foram importados na última atualização'
      assert_content 'Fabricio 10/06/2014 08:05:23'
      assert_content 'Nilson 11/06/2014 17:05:00'
      assert_no_content 'Nenhuma atualização'
      assert_current_path new_record_import_path
    end
  end

  test 'importing when there are no records to import' do
    stub_record_importer_connection [] do
      visit new_record_import_path
      click_on 'Atualizar'

      assert_flash 'Nenhum registro encontrado no relógio ponto.'
      assert_current_path record_import_path
    end
  end

  test 'importing with an invalid employee id' do
    records = test_records.first(2)
    records.last['Funcionario']['Id'] = 1

    stub_record_importer_connection records do
      visit new_record_import_path
      click_on 'Atualizar'

      assert_flash 'Não foi possível importar os registros: funcionário com o código 1 não encontrado.'
      assert_current_path new_record_import_path
    end
  end

  test 'attempt to import with a connection error' do
    stub_record_importer_connection_error do
      visit new_record_import_path
      click_on 'Atualizar'

      assert_flash 'Não foi possível comunicar-se com o relógio ponto.'
      assert_current_path new_record_import_path
    end
  end
end
