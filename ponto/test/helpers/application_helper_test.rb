require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'human_name' do
    klass = Class.new {
      def self.human_attribute_name(attr); attr.upcase; end
    }

    assert_equal 'ZOMG', human_name(klass, 'zomg')
    assert_equal 'ZOMG', human_name(klass.new, 'zomg')
  end

  test 'icon_tag' do
    assert_equal '<span class="glyphicon glyphicon-zomg"></span>', icon_tag('zomg')
  end

  test 'nav_item' do
    assert_equal '<li><a href="/">Lol</a></li>', nav_item('Lol', controller: 'dashboard')

    def controller_name; 'dashboard'; end
    assert_equal '<li class="active"><a href="/">Lol</a></li>', nav_item('Lol', controller: 'dashboard')
  end
end
