class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
  end

  def dashboard
    @game = Game.new
  end

  def user_settings
    @requests = current_user.pending_invitations
  end
end
