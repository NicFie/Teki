class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
      # scope.where.not(user: @current_user)
    end
  end

  def index

  end

  def show?
    true
  end
end
