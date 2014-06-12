require 'test_helper'

class DepartmentsTest < ActionDispatch::IntegrationTest
  setup do
    login_as users(:ademar)
  end

  test 'creating a department' do
    visit departments_path
    click_on 'Novo Departamento'
    fill_in 'Nome', with: 'Almoxarifado'
    select 'Nilson', from: 'Líder'
    click_on 'Criar Departamento'

    assert_flash 'Departamento criado com sucesso.'
    assert_content 'Almoxarifado'
    assert_content 'Nilson'
    assert_current_path department_path(Department.last)
  end

  test 'attempting to create a department with invalid fields' do
    visit new_department_path
    click_on 'Criar Departamento'

    assert_errors 'Nome não pode ficar em branco'
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

  test 'visualizing a department with its employees' do
    visit department_path(departments(:financial))

    assert_content 'Financeiro'
    assert_content 'Ademar'
    assert_content 'Carlos'
    assert_no_content 'Fabricio'
    assert_no_content 'Nilson'
  end

  test 'removing a department that has no associated employees' do
    # Cannot delete with associated employees
    Department.update_all(leader_id: nil)
    Employee.where(department_id: departments(:accounting)).delete_all

    visit departments_path
    assert_content 'Contábil'

    within(departments(:accounting)) { click_on 'Remover' }

    assert_flash 'Departamento removido com sucesso.'
    assert_no_content 'Contábil'
    assert_current_path departments_path
  end

  test 'removing a department that contains employees' do
    visit departments_path
    assert_content 'Financeiro'

    within(departments(:financial)) { click_on 'Remover' }

    assert_flash 'Departamento não pode ser removido: Não é possível excluir o ' \
      'registro pois existem funcionários dependentes.'
    assert_content 'Financeiro'
    assert_current_path departments_path
  end
end
