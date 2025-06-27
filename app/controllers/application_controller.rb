class ApplicationController < ActionController::Base
  include Pagy::Backend

  protected

  def after_sign_in_path_for(resource)
    return unless resource.class == Admin

    dashboard_path
  end

  def after_sign_out_path_for(resource)
    session_path(resource)
  end
end
