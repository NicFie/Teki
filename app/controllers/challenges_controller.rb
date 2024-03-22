# frozen_string_literal: true

class ChallengesController < ApplicationController
  def show
    random     = Challenge.all.size
    @challenge = Challenge.find(id: rand(1..random)) # chooses random challenge
    @requests  = current_user.pending_invitations
    authorize @challenge
  end

  def new; end

  def create; end
end
