class ApplicationController < ActionController::Base
  before_action :require_admin!, only: [:edit, :update, :destroy]

  private

  def require_admin!
    authenticate_user!
    unless current_user && current_user.admin?
      redirect_to root_path, flash: { error: "Insufficient privleges!" }
    end
  end
end
