ActionView::Base.field_error_proc = proc do |html_tag, instance|
  html_doc = Nokogiri::HTML::DocumentFragment.parse(html_tag, Encoding::UTF_8.to_s)
  element = html_doc.children[0]

  if element
    element.add_class('is-invalid')

    if %w[input select textarea].include?(element.name)
      attribute_name = instance.object.class.human_attribute_name(instance.instance_variable_get(:@method_name))
      error_messages = instance.error_message.map { |msg| "#{attribute_name} #{msg}" }
      instance.raw %(#{html_doc.to_html} <div class="invalid-feedback">#{error_messages.to_sentence}</div>)
    else
      instance.raw html_doc.to_html
    end
  else
    html_tag
  end
end
