require 'test_helper'

class SignInTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:carlos)
    @user.password = '87654321' # Fixtures won't set the password virtual attribute.
  end

  test 'is able to sign in' do
    visit root_path

    assert_flash 'Para continuar, efetue login ou registre-se.'
    assert_current_path new_user_session_path

    sign_in_with email: @user.email, password: @user.password

    assert_current_path root_path
    assert_flash 'Login efetuado com sucesso!'
  end

  test 'is not able to sign in with invalid credentials' do
    visit new_user_session_path
    sign_in_with email: @user.email, password: 'wrong-pwd'

    assert_current_path new_user_session_path
    assert_flash 'E-mail ou senha inválidos.'
  end

  test 'is able to sign out' do
    visit new_user_session_path
    sign_in_with email: @user.email, password: @user.password

    assert_current_path root_path

    click_link 'Sair'

    assert_current_path new_user_session_path
    assert_flash 'Saiu com sucesso.'
  end

  private

  def sign_in_with(attributes)
    fill_in 'Email', with: attributes[:email]
    fill_in 'Senha', with: attributes[:password]
    click_button 'Acessar'
  end

  def sign_out
    click_link 'Sair'
  end
end
