class Yammer::GetAllGroups
  def initialize(user)
    @yam = Yammer::Client.new(access_token: user.access_token)
  end

  def call
    yam_groups = @yam.all_groups
    yam_groups.body.map do |yam_group|
      {
        rse_id:         yam_group[:id],
        rse_network_id: yam_group[:network_id],
        full_name:      yam_group[:full_name],
        description:    yam_group[:description],
        web_url:        yam_group[:web_url],
        mugshot_url:    yam_group[:mugshot_url_template].sub('{width}x{height}', '400x400')
        ### Number of members
      }
    end
  end
end
