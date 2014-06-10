module ApplicationHelper
  def app_title
    'Udesc Ponto'
  end

  def nav_item(text, url_options)
    css = 'active' if controller_name == url_options[:controller]
    content_tag :li, link_to(text, url_options), class: css
  end
end
