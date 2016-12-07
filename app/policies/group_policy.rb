class GroupPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.joins(:memberships).where('memberships.user_id=?', user.id)
    end
  end

  def index?
    true
  end

  def show?
    record.member? user
  end

  def create?
    true
  end
end
