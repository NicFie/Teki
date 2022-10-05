class FriendshipPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    true
  end

  def new?
    create?
  end

  def create?
    if @friendship || user == record.asker
      false
    else
      true
    end
  end

  def destroy?
    true
  end
end
