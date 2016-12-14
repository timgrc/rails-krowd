class MembershipPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.joins(:memberships).where('memberships.user_id=?', user.id)
    end

    def destroy?
      record.member? user
    end
  end
end
