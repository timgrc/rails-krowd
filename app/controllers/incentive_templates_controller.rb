class IncentiveTemplatesController < ApplicationController
  skip_after_action :verify_policy_scoped

  def index
    @incentive_template = rand(10).to_s
  end
end
