class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  include Pundit::Authorization

  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?
  after_action :update_user_online, if: :user_signed_in?

  helper_method :current_game

  # Uncomment by the end of the project, we need pundit error msgs atm!

  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  # def user_not_authorized
  #   flash[:alert] = "You are not authorized to perform this action."
  #   redirect_to(root_path)
  # end
  #
  def current_game
    game_id = params[:game_id] || request.path.match(/\/games\/(\d+)/)[1]
    @current_game ||= Game.find_by(id: game_id) if game_id.present?
  end

  private

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end

  def after_sign_in_path_for(resource)
    dashboard_path
  end

  def update_user_online
    current_user.try :touch
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username avatar score])
    update_attrs = [:password, :password_confirmation, :current_password]
    devise_parameter_sanitizer.permit(:account_update, keys: update_attrs)
  end
end
