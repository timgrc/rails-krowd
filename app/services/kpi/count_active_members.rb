class Kpi::CountActiveMembers
  def initialize
  end

  def call
    User.count
  end
end
