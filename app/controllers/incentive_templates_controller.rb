class IncentiveTemplatesController < ApplicationController
  skip_after_action :verify_policy_scoped, :verify_authorized

  def change
    # @incentive_template_id
    @incentive_template = IncentiveTemplate.where.not(id: @incentive_template_id).sample
  end
end
