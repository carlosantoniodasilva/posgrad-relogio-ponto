require 'test_helper'

class OvertimeBankPaymentsTest < ActionDispatch::IntegrationTest
  setup do
    login_as users(:ademar)
  end

  test 'creating an overtime_bank_payment' do
    visit overtime_bank_payments_path
    click_on 'Novo Pagamento de Horas'

    select 'Ademar', from: 'Funcionário'
    fill_in 'Horas pagas', with: '01.25'
    click_on 'Criar Pagamento de Horas'

    assert_flash 'Pagamento de Horas criado com sucesso.'
    assert_content 'Ademar 1,25'
    assert_current_path overtime_bank_payments_path

    # visit employee_path(employees(:ademar))

    # assert_content 'Saldo de Horas: 0,25'
  end

  test 'attempting to create an overtime_bank_payment with invalid fields' do
    visit new_overtime_bank_payment_path
    click_on 'Criar Pagamento de Horas'

    assert_errors 'Funcionário não pode ficar em branco', 'Horas pagas não pode ficar em branco'
  end

  test 'removing an overtime_bank_payment' do
    visit overtime_bank_payments_path
    assert_content 'Fabricio'

    within(overtime_bank_payments(:fabricio)) { click_on 'Remover' }

    assert_flash 'Pagamento de Horas removido com sucesso.'
    assert_no_content 'Fabricio'
    assert_current_path overtime_bank_payments_path

    # visit employee_path(employees(:fabricio))

    # assert_content 'Saldo de Horas: 18,75'
  end
end
