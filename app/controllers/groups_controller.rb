require 'yammer'

class GroupsController < ApplicationController
  before_action :find_group, only: [:show] # :destoy ?

  def index
    @groups     = policy_scope(Group)
    @group      = Group.new
    @yam_groups = Yammer::GetAllGroups.new(current_user).call
  end

  def show
    @push_default_value = {
      awards: awards,
      incentive: incentive
    }
    @push_message = PushMessage.new
    @incentive_id = 5

  end

  def create
    yam_groups            = Yammer::GetAllGroups.new(current_user).call
    group_params_from_api = yam_groups.find do |yam_group|
      yam_group[:full_name] == params[:group][:full_name]
    end
    @group = current_user.groups.build(group_params_from_api)
    authorize @group

    if @group.save
      Membership.create!(user: current_user, group: @group)
      redirect_to groups_path
      # redirect_to group_path(@group)
    else
      # render 'new'
    end
  end

  # def destroy
  # end

  private

  def find_group
    @group = Group.find(params[:id])
    authorize @group
  end

  def awards
    influencer = KpiDash.new(@group, 'influencer').call
    activist   = KpiDash.new(@group, 'activist').call
    networker  = KpiDash.new(@group, 'networker').call
    inventor   = KpiDash.new(@group, 'inventor').call
    mastermind = KpiDash.new(@group, 'mastermind').call
    "Special congratulations for this week :
    The influencer: #{influencer[:user].first_name} #{influencer[:user].last_name.capitalize}
    The activist: #{activist[:user].first_name} #{activist[:user].last_name.capitalize}
    The networker: #{networker[:user].first_name} #{networker[:user].last_name.capitalize}
    The inventor: #{inventor[:user].first_name} #{inventor[:user].last_name.capitalize}
    The mastermind: #{mastermind[:user].first_name} #{mastermind[:user].last_name.capitalize}"
  end

  def incentive
    if IncentiveTemplate.all.count != 0
      IncentiveTemplate.all.sample.body
    end
  end
end
