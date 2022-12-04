class LeaguesController < ApplicationController
  def index
    @leagues = policy_scope(League)
    @leagues = current_user.leagues
    @requests = current_user.pending_invitations
  end

  def new
  end

  def create
  end

  def show
    @league = League.find(params[:id])
    @requests = current_user.pending_invitations

    authorize @league
  end
end
