require 'test_helper'

class HolidayImportsTest < ActionDispatch::IntegrationTest
  setup do
    login_as users(:carlos)
  end

  test 'importing holidays from a valid csv file' do
    visit new_holiday_import_path

    attach_file 'Arquivo', fixture_path + 'holidays/valid.csv'
    click_on 'Importar Arquivo'

    assert_flash 'Importação de feriados efetuada com sucesso: 2 criado(s), 0 atualizado(s).'
    assert_content '01/05/2014 Dia do Trabalho'
    assert_content '12/10/2014 Dia de Nossa Senhora Aparecida'
    assert_current_path holidays_path
  end

  test 'importing holidays from an invalid csv file' do
    visit new_holiday_import_path

    attach_file 'Arquivo', fixture_path + 'holidays/invalid_date.csv'
    click_on 'Importar Arquivo'

    assert_flash 'Não foi possível ler todos os feriados do arquivo'
    assert_current_path holiday_import_path
  end

  test 'attempt to import holidays without sending a file' do
    visit new_holiday_import_path
    click_on 'Importar Arquivo'

    assert_flash 'Error ao importar arquivo: Arquivo não é válido.'
    assert_current_path holiday_import_path
  end
end
