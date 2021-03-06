require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'human_name' do
    klass = Class.new {
      def self.human_attribute_name(attr); attr.upcase; end
    }

    assert_equal 'ZOMG', human_name(klass, 'zomg')
    assert_equal 'ZOMG', human_name(klass.new, 'zomg')
  end

  test 'display_balance' do
    assert_equal '2,25', display_balance(2.25)
    assert_equal '4,50', display_balance(4.5)
    assert_equal '9,00', display_balance(9)
  end

  test 'display_id_name' do
    object = Struct.new(:id, :name).new('99', 'Teste')
    assert_equal '99 - Teste', display_id_name(object)
  end

  test 'flash_tag' do
    assert_equal '<div class="alert alert-success"><span class="glyphicon glyphicon-yay"></span> Message</div>',
      flash_tag('Message', 'yay', 'success')
  end

  test 'icon_tag' do
    assert_equal '<span class="glyphicon glyphicon-zomg"></span>', icon_tag('zomg')
  end

  test 'icon_button_to' do
    assert_equal '<a class="btn btn-default" href="/"><span class="glyphicon glyphicon-zomg"></span> Link</a>',
      icon_button_to('zomg', 'Link', '/')
  end

  test 'icon_link_to' do
    assert_equal '<a href="/"><span class="glyphicon glyphicon-zomg"></span> Link</a>',
      icon_link_to('zomg', 'Link', '/')
  end

  test 'nav_item' do
    assert_equal '<li><a href="/">Lol</a></li>', nav_item('Lol', controller: 'dashboard')

    def controller_name; 'dashboard'; end
    assert_equal '<li class="active"><a href="/">Lol</a></li>', nav_item('Lol', controller: 'dashboard')
  end
end
