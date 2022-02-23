class ApplicationController < ActionController::Base

  #protect_from_forgery with: :exception
  #before_action :authenticate_user!
  #layout :layout_by_resource
  #before_action :configure_permitted_parameters, if: :devise_controller?

#  protected

  # def configure_permitted_parameters
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :username, :password, :password_confirmation, roles: []])
  # end

  # private
  #
  # def layout_by_resource
  #   if devise_controller?
  #     "devise"
  #   else
  #     "application"
  #   end
  # end

end
