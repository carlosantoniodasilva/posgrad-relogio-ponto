require 'test_helper'

class HolidaysTest < ActionDispatch::IntegrationTest
  setup do
    login_as users(:ademar)
  end

  test 'creating a holiday' do
    visit holidays_path
    click_on 'Novo Feriado'
    fill_in 'Data', with: '2014-04-21'
    fill_in 'Nome', with: 'Tiradentes'
    click_on 'Criar Feriado'

    assert_flash 'Feriado criado com sucesso.'
    assert_content '21/04/2014'
    assert_content 'Tiradentes'
    assert_current_path holidays_path
  end

  test 'attempting to create a holiday with invalid fields' do
    visit new_holiday_path
    click_on 'Criar Feriado'

    assert_errors 'Data não pode ficar em branco', 'Nome não pode ficar em branco'
    assert_field 'Nome', with: ''
  end

  test 'editing a holiday' do
    visit holidays_path
    within(holidays(:corpus_christi)) { click_on 'Editar' }

    fill_in 'Nome', with: 'Tiradentes'
    click_on 'Atualizar Feriado'

    assert_flash 'Feriado atualizado com sucesso.'
    assert_content 'Tiradentes'
    assert_no_content 'Corpus'
    assert_current_path holidays_path
  end

  test 'removing a holiday' do
    visit holidays_path
    assert_content 'Independência do Brasil'

    within(holidays(:independencia)) { click_on 'Remover' }

    assert_flash 'Feriado removido com sucesso.'
    assert_no_content 'Independência'
    assert_current_path holidays_path
  end
end
