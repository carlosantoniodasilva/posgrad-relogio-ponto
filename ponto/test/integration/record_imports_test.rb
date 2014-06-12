require 'test_helper'
require 'support/record_importer'

class RecordImportsTest < ActionDispatch::IntegrationTest
  include Support::RecordImporter

  setup do
    login_as users(:carlos)
  end

  test 'importing records for the first time from the api' do
    RecordGroup.delete_all
    records = [
      { 'Id' => employees(:fabricio).id, 'DataRegistro' => '10/06/2014', 'HoraRegistro' => '08:05:23' },
      { 'Id' => employees(:nilson).id,   'DataRegistro' => '11/06/2014', 'HoraRegistro' => '07:58:43' }
    ]

    stub_record_importer_connection records do
      visit record_import_path

      assert_title 'Importar Registros'
      assert_content 'Nenhuma atualização de registros ponto foi efetuada ainda.'

      click_on 'Atualizar'

      assert_flash 'Importação de registros do ponto efetuada com sucesso.'
      assert_content '2 registros foram importados na última atualização'
      assert_content 'Fabricio 10/06/2014 08:05:23'
      assert_content 'Nilson 11/06/2014 07:58:43'
      assert_no_content 'Nenhuma atualização'
      assert_current_path record_import_path
    end
  end

  test 'importing when there are no records to import' do
    stub_record_importer_connection [] do
      visit record_import_path
      click_on 'Atualizar'

      assert_flash 'Nenhum registro encontrado no relógio ponto.'
      assert_current_path record_import_path
    end
  end

  test 'importing with an invalid employee id' do
    records = [
      { 'Id' => employees(:fabricio).id, 'DataRegistro' => '10/06/2014', 'HoraRegistro' => '08:05:23' },
      { 'Id' => '1',                     'DataRegistro' => '11/06/2014', 'HoraRegistro' => '07:58:43' }
    ]

    stub_record_importer_connection records do
      visit record_import_path
      click_on 'Atualizar'

      assert_flash 'Não foi possível importar os registros: funcionário com o código 1 não encontrado.'
      assert_current_path record_import_path
    end
  end

  test 'attempt to import with a connection error' do
    stub_record_importer_connection_error do
      visit record_import_path
      click_on 'Atualizar'

      assert_flash 'Não foi possível comunicar-se com o relógio ponto.'
      assert_current_path record_import_path
    end
  end
end
