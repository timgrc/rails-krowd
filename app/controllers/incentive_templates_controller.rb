class IncentiveTemplatesController < ApplicationController
  skip_after_action :verify_policy_scoped, :verify_authorized
  skip_before_action :authenticate_user!, only: [:change]

  def change
    @incentive_template = IncentiveTemplate.where.not(id: @incentive_template_id).sample
  end
end
