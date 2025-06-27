ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
    unless html_tag =~ /^<label|<input class=\"form-check-input subcat_option subcat_checkbox/
      %{<div class="has-error">#{html_tag}<span class="help-block">#{instance.error_message.join(', ')}</span></div>}.html_safe
      #%{<div class="dy-has-error-contact">#{html_tag}<span class="help-block">#{instance.error_message.join(', ')}</span></div>}.html_safe
    else
      %{#{html_tag}}.html_safe
    end
  end