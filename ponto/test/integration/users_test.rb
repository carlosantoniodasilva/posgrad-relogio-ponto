require 'test_helper'

class UsersTest < ActionDispatch::IntegrationTest
  setup do
    login_as users(:ademar)
  end

  test 'creating a user with a new employee' do
    visit new_employee_path

    fill_in 'Nome', with: 'Almoxarifado'
    select 'Financeiro', from: 'Departamento'
    fill_in 'Email', with: 'newuser@example.com'
    fill_in 'Senha', with: 'newuser.123'
    fill_in 'Confirmação de senha', with: 'newuser.123'
    choose 'RH'
    click_on 'Criar Funcionário'

    assert_flash 'Funcionário criado com sucesso.'
    assert_content 'Almoxarifado'
    assert_content 'Financeiro'
    assert_content 'newuser@example.com'
  end

  test 'attempting to create a user with a new employee and invalid fields' do
    visit new_employee_path

    fill_in 'Nome', with: 'Almoxarifado'
    select 'Financeiro', from: 'Departamento'
    fill_in 'Email', with: 'newuser'
    fill_in 'Senha', with: 'newuser.123'
    fill_in 'Confirmação de senha', with: 'newuser.321'
    click_on 'Criar Funcionário'

    assert_errors 'Email não é válido', 'Confirmação de senha não é igual a Senha'
    assert_field 'Email', with: 'newuser'
  end

  test 'creating a user with an existing employee' do
    visit edit_employee_path(employees(:nilson))

    fill_in 'Email', with: 'newuser@example.com'
    fill_in 'Senha', with: 'newuser.123'
    fill_in 'Confirmação de senha', with: 'newuser.123'
    choose 'Admin'
    click_on 'Atualizar Funcionário'

    assert_flash 'Funcionário atualizado com sucesso.'
    assert_content 'newuser@example.com'
    assert_current_path employee_path(employees(:nilson))
  end

  test 'editing an existing user without changing the password' do
    visit edit_employee_path(employees(:carlos))

    fill_in 'Email', with: 'carlos.new@example.com'
    click_on 'Atualizar Funcionário'

    assert_flash 'Funcionário atualizado com sucesso.'
    assert_content 'carlos.new@example.com'
    assert_no_content 'carlos@example.com'
    assert_current_path employee_path(employees(:carlos))
  end

  test 'editing an existing user changing the password' do
    visit edit_employee_path(employees(:carlos))

    fill_in 'Senha', with: 'newpwd.123'
    fill_in 'Confirmação de senha', with: 'newpwd.123'
    click_on 'Atualizar Funcionário'

    assert_flash 'Funcionário atualizado com sucesso.'
    assert_current_path employee_path(employees(:carlos))
    assert users(:carlos).reload.valid_password?('newpwd.123')
  end

  test 'removing the user from an existing employee' do
    visit edit_employee_path(employees(:carlos))

    check 'Remover o usuário'
    click_on 'Atualizar Funcionário'

    assert_flash 'Funcionário atualizado com sucesso.'
    assert_content 'Carlos'
    assert_no_content 'carlos@example.com'
    assert_raise(ActiveRecord::RecordNotFound) { users(:carlos).reload }
  end
end
