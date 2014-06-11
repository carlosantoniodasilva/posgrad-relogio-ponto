require 'test_helper'

class EmployeesTest < ActionDispatch::IntegrationTest
  setup do
    login_as users(:ademar)
  end

  test 'creating a employee' do
    visit employees_path
    click_on 'Novo Funcionário'
    fill_in 'Nome', with: 'Almoxarifado'
    select 'Financeiro', from: 'Departamento'
    click_on 'Criar Funcionário'

    assert_flash 'Funcionário criado com sucesso.'
    assert_content 'Almoxarifado'
    assert_content 'Financeiro'
    assert_current_path employee_path(Employee.last)
  end

  test 'attempting to create a employee with invalid fields' do
    visit new_employee_path
    click_on 'Criar Funcionário'

    assert_errors 'não pode ficar em branco'
    assert_field 'Nome', with: ''
  end

  test 'editing a employee' do
    visit employees_path
    within(employees(:nilson)) { click_on 'Editar' }
    fill_in 'Nome', with: 'Almoxarifado'
    click_on 'Atualizar Funcionário'

    assert_flash 'Funcionário atualizado com sucesso.'
    assert_content 'Almoxarifado'
    assert_no_content 'Financeiro'
    assert_current_path employee_path(employees(:nilson).reload)
  end

  test 'removing a employee' do
    visit employees_path
    assert_content 'Nilson'

    within(employees(:nilson)) { click_on 'Remover' }

    assert_flash 'Funcionário removido com sucesso.'
    assert_no_content 'Nilson'
    assert_current_path employees_path
  end
end
