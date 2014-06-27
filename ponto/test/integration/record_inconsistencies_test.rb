require 'test_helper'

class RecordInconsistenciesTest < ActionDispatch::IntegrationTest
  setup do
    login_as users(:ademar)
  end

  test 'visualize all pending inconsistencies grouped by employee' do
    records(:ademar_1).create_inconsistency! status: 'pending', kind: 'below_limit'
    records(:carlos_1).create_inconsistency! status: 'pending', kind: 'above_limit'

    visit root_path

    assert_title 'Inconsistências no Ponto'

    assert_link 'Ademar', href: employee_path(employees(:ademar))
    within records(:ademar_1) do
      assert_content '11/06/2014 08:00:00, 12:02:00, 13:00:00 e 17:00:00'
      assert_content 'Menos registros'
      assert_link 'Justificar'
    end

    assert_link 'Carlos', href: employee_path(employees(:carlos))
    within records(:carlos_1) do
      assert_content '10/06/2014 12:59:00 e 17:01:00'
      assert_content 'Mais registros'
      assert_link 'Justificar'
    end
  end

  test 'justify inconsistency granting overtime hours to employee' do
    records(:carlos_1).create_inconsistency! status: 'pending', kind: 'below_limit'

    visit root_path

    within records(:carlos_1) do
      click_link 'Justificar'

      within '.modal' do
        fill_in 'Justificativa', with: 'OK'
        click_on 'Justificar abonando horas'
      end
    end

    assert_flash 'Inconsistência atualizada com sucesso.'
    assert_current_path root_path
    assert_no_content 'Carlos'

    visit employee_path(employees(:carlos))

    within records(:carlos_1) do
      assert_content 'Menos registros'
      assert_content 'OK'
      assert_css 'span[data-title=Abonado]'
    end
  end

  test 'justify inconsistency verifying but not granting overtime hours to employee' do
    records(:carlos_1).create_inconsistency! status: 'pending', kind: 'below_limit'

    visit root_path

    within records(:carlos_1) do
      click_link 'Justificar'

      within '.modal' do
        fill_in 'Justificativa', with: 'Não OK'
        click_on 'Verificar sem abonar horas'
      end
    end

    assert_flash 'Inconsistência atualizada com sucesso.'
    assert_current_path root_path
    assert_no_content 'Carlos'

    visit employee_path(employees(:carlos))

    within records(:carlos_1) do
      assert_content 'Menos registros'
      assert_content 'Não OK'
      assert_css 'span[data-title=Verificado]'
    end
  end
end
