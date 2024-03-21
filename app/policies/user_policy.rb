class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
      # scope.where.not(user: @current_user)
    end
  end

  def index; end

  def send_game_invitation?
    true
  end

  def show?
    true
  end

  def send_invitation?
    true
  end
end
