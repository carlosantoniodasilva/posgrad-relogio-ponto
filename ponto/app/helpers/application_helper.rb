module ApplicationHelper
  def app_title
    'Udesc Ponto'
  end

  def display_balance(value)
    number_with_precision value, precision: 2
  end

  def display_id_name(record)
    "#{record.id} - #{record.name}"
  end

  def flash_tag(message, icon_type, alert_type)
    content_tag :div, icon_tag(icon_type) << " " << message, class: "alert alert-#{alert_type}"
  end

  def icon_tag(type)
    content_tag :span, nil, class: "glyphicon glyphicon-#{type}"
  end

  def icon_button_to(*args)
    options = args.extract_options!
    options[:class] = "btn btn-default #{options[:class]}".rstrip
    icon_link_to(*(args << options))
  end

  def icon_link_to(icon_type, text, *args)
    link_to icon_tag(icon_type) << " " << text, *args
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
