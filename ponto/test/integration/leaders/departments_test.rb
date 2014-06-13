require 'test_helper'

module Leaders
  class DepartmentsTest < ActionDispatch::IntegrationTest
    setup do
      login_as users(:fabricio)
    end

    test 'viewing only led departments' do
      visit departments_path

      assert_content 'Financeiro'
      assert_no_content 'Contábil'

      visit department_path(departments(:financial))

      assert_content 'Financeiro'
      assert_content 'Ademar'
      assert_content 'Carlos'
      assert_no_content 'Nilson'

      assert_raise ActiveRecord::RecordNotFound do
        visit department_path(departments(:accounting))
      end
    end

    test 'cannot manage department' do
      visit departments_path
      assert_no_link 'Novo'
      assert_no_link 'Editar'
      assert_no_link 'Remover'

      visit department_path(departments(:financial))
      assert_no_link 'Editar'
      assert_no_link 'Remover'

      visit new_department_path
      assert_no_access

      visit edit_department_path(departments(:accounting))
      assert_no_access
    end

    private

    def assert_no_access
      assert_flash 'Você não tem acesso.'
      assert_current_path root_path
    end
  end
end
