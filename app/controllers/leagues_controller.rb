class LeaguesController < ApplicationController
  def index
    @leagues = current_user.leagues
    @requests = current_user.pending_invitations

    skip_authorization
  end

  def new
  end

  def create
  end

  def show
  end
end
