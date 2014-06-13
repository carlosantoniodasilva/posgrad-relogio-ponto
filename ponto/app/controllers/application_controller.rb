class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  add_flash_types :error

  before_action :authenticate_user!

  class << self
    protected

    def authorize_roles(*roles)
      options = roles.extract_options!

      roles = roles.map!(&:to_s)
      raise "Invalid roles to authenticate: #{roles.join(', ')}" if (roles - User::ROLES).any?

      before_action options do
        unless roles.include?(current_user.role)
          redirect_to root_path, error: 'Você não tem acesso.'
        end
      end
    end
  end

  protected

  def after_sign_out_path_for(resource)
    new_session_path(resource)
  end
end
