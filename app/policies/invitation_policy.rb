class InvitationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def send_invitation?
    true
  end
end
