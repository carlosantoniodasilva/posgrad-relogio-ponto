class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  protected

  def after_sign_out_path_for(resource)
    new_session_path(resource)
  end
end