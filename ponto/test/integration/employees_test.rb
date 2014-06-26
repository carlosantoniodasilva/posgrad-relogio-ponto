require 'test_helper'

class EmployeesTest < ActionDispatch::IntegrationTest
  setup do
    login_as users(:ademar)
  end

  test 'creating an employee' do
    visit employees_path
    click_on 'Novo Funcionário'
    fill_in 'Nome', with: 'Almoxarifado'
    select 'Financeiro', from: 'Departamento'
    click_on 'Criar Funcionário'

    assert_flash 'Funcionário criado com sucesso.'
    assert_content 'Almoxarifado'
    assert_content 'Financeiro'
    assert_content 'Saldo de horas: 0,00'
    assert_current_path employee_path(Employee.last)
  end

  test 'attempting to create an employee with invalid fields' do
    visit new_employee_path
    click_on 'Criar Funcionário'

    assert_errors 'Nome não pode ficar em branco'
    assert_field 'Nome', with: ''
  end

  test 'editing an employee' do
    visit employees_path
    within(employees(:nilson)) { click_on 'Editar' }

    fill_in 'Nome', with: 'Almoxarifado'
    click_on 'Atualizar Funcionário'

    assert_flash 'Funcionário atualizado com sucesso.'
    assert_content 'Almoxarifado'
    assert_no_content 'Financeiro'
    assert_current_path employee_path(employees(:nilson).reload)
  end

  test 'visualizing an employee with its records' do
    travel_to Date.parse('2014-06-12') do
      visit employee_path(employees(:ademar))

      assert_content 'Ademar'
      assert_content 'Saldo de horas: 1,50'
      assert_content 'Registro Ponto'
      assert_field 'Entre', with: '2014-06-01'
      assert_field 'e', with: '2014-06-12'
      assert_content '2 registros encontrados entre 01/06/2014 e 12/06/2014.'
      assert_css '.record', count: 2

      fill_in 'Entre', with: '2014-06-12'
      fill_in 'e', with: '2014-06-12'
      click_on 'Ver'

      assert_field 'Entre', with: '2014-06-12'
      assert_field 'e', with: '2014-06-12'
      assert_content '1 registro encontrado entre 12/06/2014 e 12/06/2014.'
      assert_css '.record', count: 1

      fill_in 'Entre', with: '2014-06-25'
      fill_in 'e', with: '2014-06-30'
      click_on 'Ver'

      assert_field 'Entre', with: '2014-06-25'
      assert_field 'e', with: '2014-06-30'
      assert_content 'Nenhum registro encontrado entre 25/06/2014 e 30/06/2014.'
      assert_no_css '.record'
    end
  end

  test 'removing an employee' do
    visit employees_path
    assert_content 'Nilson'

    within(employees(:nilson)) { click_on 'Remover' }

    assert_flash 'Funcionário removido com sucesso.'
    assert_no_content 'Nilson'
    assert_current_path employees_path
  end
end
