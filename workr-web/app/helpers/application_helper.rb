module ApplicationHelper
  def body_id
    "#{controller.class.name.underscore.dasherize.gsub("-controller","").gsub("/", "-")}-#{action_name.dasherize}"
  end

  def error_messages_for!(resource)
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join                                                                      
    sentence = I18n.t("errors.messages.not_saved",                                                                                                         
                      :count => resource.errors.count,                                                                                                     
                      :resource => resource.class.model_name.human.downcase)                                                                               

    html = <<-HTML
    <div class="panel panel-danger">
      <div class="panel-heading">#{sentence}</div>
      <ul>#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end
end
