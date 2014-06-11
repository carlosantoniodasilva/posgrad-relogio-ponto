require 'test_helper'

class DepartmentsTest < ActionDispatch::IntegrationTest
  setup do
    login_as users(:ademar)
  end

  test 'creating a department' do
    visit departments_path
    click_on 'Novo Departamento'
    fill_in 'Nome', with: 'Almoxarifado'
    click_on 'Criar Departamento'

    assert_flash 'Departamento criado com sucesso.'
    assert_content 'Almoxarifado'
    assert_current_path department_path(Department.last)
  end

  test 'attempting to create a department with invalid fields' do
    visit new_department_path
    click_on 'Criar Departamento'

    assert_errors 'não pode ficar em branco'
    assert_field 'Nome', with: ''
  end

  test 'editing a department' do
    visit departments_path
    within(departments(:financial)) { click_on 'Editar' }
    fill_in 'Nome', with: 'Almoxarifado'
    click_on 'Atualizar Departamento'

    assert_flash 'Departamento atualizado com sucesso.'
    assert_content 'Almoxarifado'
    assert_no_content 'Financeiro'
    assert_current_path department_path(departments(:financial).reload)
  end

  test 'removing a department' do
    visit departments_path
    assert_content 'Financeiro'

    within(departments(:financial)) { click_on 'Remover' }

    assert_flash 'Departamento removido com sucesso.'
    assert_no_content 'Financeiro'
    assert_current_path departments_path
  end
end
