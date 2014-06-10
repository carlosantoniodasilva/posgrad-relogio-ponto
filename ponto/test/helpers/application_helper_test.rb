require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'nav_item' do
    assert_equal '<li><a href="/">Lol</a></li>', nav_item('Lol', controller: 'dashboard')

    def controller_name; 'dashboard'; end
    assert_equal '<li class="active"><a href="/">Lol</a></li>', nav_item('Lol', controller: 'dashboard')
  end
end
