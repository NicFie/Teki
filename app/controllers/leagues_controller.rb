class LeaguesController < ApplicationController
  def index
    @leagues = policy_scope(League)
    @leagues = current_user.leagues
    @requests = current_user.pending_invitations

    # authorize @leagues
  end

  def new
  end

  def create
  end

  def show
  end
end
