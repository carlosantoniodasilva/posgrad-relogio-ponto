module ApplicationHelper
  def app_title
    'Udesc Ponto'
  end

  def icon_tag(type)
    content_tag :span, nil, class: "glyphicon glyphicon-#{type}"
  end

  def human_name(object, attribute)
    klass = object.respond_to?(:human_attribute_name) ? object : object.class
    klass.human_attribute_name(attribute)
  end

  def nav_item(text, url_options)
    css = 'active' if controller_name == url_options[:controller]
    content_tag :li, link_to(text, url_options), class: css
  end
end
