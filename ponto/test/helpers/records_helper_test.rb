require 'test_helper'

class RecordsHelperTest < ActionView::TestCase
  test 'display_record_times' do
    times = [Time.new(2000, 1, 1, 17, 45, 9), Time.new(2000, 1, 1, 8, 03, 42)]
    assert_equal '17:45:09 e 08:03:42', display_record_times(times)
  end

  test 'inconsistency_kind' do
    inconsistency = Struct.new(:kind).new('holiday')
    assert_equal 'Feriado', inconsistency_kind(inconsistency)
  end

  test 'inconsistency_status' do
    inconsistency = Struct.new(:status).new('pending')
    assert_equal 'Pendente', inconsistency_status(inconsistency)
  end

  def icon_tag(icon); "<icon>#{icon}</icon>".html_safe; end

  test 'inconsistency_status_icon' do
    assert_equal '<icon>flag</icon>',
      inconsistency_status_icon(:pending)
  end

  test 'inconsistency_status_icon_tooltip' do
    inconsistency = Struct.new(:status).new('pending')
    assert_equal '<span data-title="Pendente" data-toggle="tooltip"><icon>flag</icon></span>',
      inconsistency_status_icon_tooltip(inconsistency)
  end
end
