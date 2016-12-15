class IncentiveTemplatesController < ApplicationController
  skip_after_action :verify_policy_scoped

  def index
    @incentive_template = IncentiveTemplate.all.sample
  end
end
