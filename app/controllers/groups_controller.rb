require 'yammer'

class GroupsController < ApplicationController
  before_action :find_group, only: [:show] # :destoy ?
  before_action :set_demo, only: [:show, :demo] # :destoy ?
  skip_before_action :authenticate_user!, only: [:demo]

  def index
    @groups     = policy_scope(Group)
    @group      = Group.new
    @yam_groups = Yammer::GetAllGroups.new(current_user).call
    @yam_groups = @yam_groups.select do |group|
      Membership.joins(:group).where('groups.full_name = ? and memberships.user_id = ? and memberships.user_in_dash = true', group[:full_name], current_user.id).empty?
    end
  end

  def show
    @push_default_value = {
      awards: awards,
      incentive: incentive
    }

    @push_message = PushMessage.new
  end

  def demo
    @demo = true
    @group = Group.find_by_full_name('Innovation Challenge - The Company')
    authorize @group

    @push_default_value = {
      awards: awards,
      incentive: incentive
    }

    #@push_message = PushMessage.new
  end

  def create
    yam_groups            = Yammer::GetAllGroups.new(current_user).call
    group_params_from_api = yam_groups.find do |yam_group|
      yam_group[:full_name] == params[:group][:full_name]
    end
    if Group.where('full_name = ?', group_params_from_api[:full_name]).empty?
      @group = current_user.groups.build(group_params_from_api)
      authorize @group
      @group.save
      # Yammer::UpdateGroup.new(current_user, @group).call
    else
      @group = Group.where('full_name = ?', group_params_from_api[:full_name]).first
      authorize @group
    end

    if Membership.where('user_id = ? and group_id = ?', current_user.id, @group.id).empty?
      Membership.create!(user: current_user, group: @group, user_in_dash: true)
    else
      membership = Membership.where('user_id = ? and group_id = ?', current_user.id, @group.id).first
      membership.user_in_dash = true
      membership.save
    end

    redirect_to groups_path
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
    - The influencer: #{influencer[:user].first_name} #{influencer[:user].last_name.capitalize}
    - The activist: #{activist[:user].first_name} #{activist[:user].last_name.capitalize}
    - The networker: #{networker[:user].first_name} #{networker[:user].last_name.capitalize}
    - The inventor: #{inventor[:user].first_name} #{inventor[:user].last_name.capitalize}
    - The mastermind: #{mastermind[:user].first_name} #{mastermind[:user].last_name.capitalize}"
  end

  def incentive
    if IncentiveTemplate.all.count != 0
      incentive_template_sample = IncentiveTemplate.all.sample
      @incentive_template_id = incentive_template_sample.id
      incentive_template_sample.body
    end
  end

  def set_demo
    @demo = false
  end
end
