class ApplicationController < ActionController::Base
  include UsersAndAdminsHelper
  protect_from_forgery with: :exception

  def authenticate_admin!
    unless user_is_admin?
      redirect_to unknown_users_path, alert: "You must be an Admin to view that page."
    end
  end
end
