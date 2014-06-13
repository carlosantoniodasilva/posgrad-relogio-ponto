require 'test_helper'

module Leaders
  class EmployeesTest < ActionDispatch::IntegrationTest
    setup do
      login_as users(:fabricio)
    end

    test 'viewing only led employees' do
      visit employees_path

      assert_content 'Ademar'
      assert_content 'Carlos'
      assert_no_content 'Nilson'

      visit employee_path(employees(:ademar))

      assert_content 'Financeiro'
      assert_no_content 'Contábil'

      assert_raise ActiveRecord::RecordNotFound do
        visit employee_path(employees(:nilson))
      end
    end

    test 'cannot manage employee' do
      visit employees_path
      assert_no_link 'Novo'
      assert_no_link 'Editar'
      assert_no_link 'Remover'

      visit employee_path(employees(:ademar))
      assert_no_link 'Editar'
      assert_no_link 'Remover'

      visit new_employee_path
      assert_no_access

      visit edit_employee_path(employees(:nilson))
      assert_no_access
    end

    private

    def assert_no_access
      assert_flash 'Você não tem acesso.'
      assert_current_path root_path
    end
  end
end
