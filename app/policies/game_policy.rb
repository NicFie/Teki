# frozen_string_literal: true

class GamePolicy < ApplicationPolicy
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
    true
  end

  def edit?
    true
  end

  def update?
    true
  end

  def game_test?
    true
  end
end
