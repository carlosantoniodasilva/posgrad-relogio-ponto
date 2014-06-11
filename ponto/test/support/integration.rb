module Support
  module Integration
    def assert_errors(*errors)
      assert_css '#error_explanation', text: /Não foi possível salvar/
      errors.each do |error|
        assert_content error
      end
    end

    def assert_content(content)
      assert has_content?(content), "Expected to have content #{content}"
    end

    def assert_no_content(content)
      assert has_no_content?(content), "Expected not to have content #{content}"
    end

    def assert_css(css, options = nil)
      assert has_css?(css, options), "Expected to have css #{css}#{" with options #{options.inspect}" if options}"
    end

    def assert_no_css(css, options = nil)
      assert has_no_css?(css, options), "Expected to not have css #{css}#{" with options #{options.inspect}" if options}"
    end

    def assert_current_path(expected_path)
      assert_equal expected_path, current_path
    end

    def assert_field(field, options = nil)
      assert has_field?(field, options), "Expected to have field #{field}#{" with options #{options.inspect}" if options}"
    end

    def assert_no_field(field, options = nil)
      assert has_no_field?(field, options), "Expected to not have field #{field}#{" with options #{options.inspect}" if options}"
    end

    def assert_flash(message)
      assert has_css?('.alert', text: message), "Flash #{message.inspect} does not exist in the page"
    end

    def assert_link(text)
      assert has_link?(text), "Link #{text} does not exist in the page"
    end

    def assert_no_link(text)
      assert has_no_link?(text), "Link #{text} exists in the page"
    end

    def assert_title(message)
      assert_css 'h1.page-header', text: message
    end
  end
end
