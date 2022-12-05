class LeaguesController < ApplicationController
  before_action :add_requests, only: %i[index new show]

  def index
    @leagues = policy_scope(League)
    @leagues = current_user.leagues
  end

  def new
    @league = League.new

    authorize @league
  end

  def create
    @league = League.new(league_params)
    @league.save!
    user_league = UserLeague.new(league: @league, user: current_user)
    user_league.save!

    redirect_to leagues_path

    authorize @league
  end

  def show
    @league = League.find(params[:id])

    authorize @league
  end

  private

  def league_params
    params.require(:league).permit(:name)
  end

  def add_requests
    @requests = current_user.pending_invitations
  end
end
