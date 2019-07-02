class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def design_system_policy
    @design_system_policy ||= DesignSystemPolicy.new
  end
end
