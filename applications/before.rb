
configure do
	set :home_page, '/work/home'
end

before '/work/*' do

	@title = "Cloud workstation"

	@work_menu = {
		:home => '/work/home',
		:task => '/work/task',
		:help => '/work/help'
	}

	@left_menu = {}

	_login? '/work/login'

end

before '/work/home*' do

	@left_menu = {
		:settings	=> {
			#:info	=> '/work/home/settings/info',
			#:contact=> '/work/home/settings/contact',
			#:secure	=> '/work/home/settings/secure',
			:group	=> '/work/home/group/list',
			:messages => '/work/home/message/group',
		},
# 		:messages	=> {
# 			:group	=> '/work/home/message/group',
# 			:user	=> '/work/home/message/user',
# 		},
		:support	=> {
			:suggestion => '/work/home/support/post/1',
			:report	=> '/work/home/support/post/2',
			:decision	=> '/work/home/support/post/3',
		}
	}

end

before '/work/help*' do

	@left_menu = {
		:docs	=> {
			:faq	=> '/work/help/docs/post/4',
		},
		:tool => {}
	}
	_vars(:work_tool_type).each do | a |
		@left_menu[:tool][a.to_sym] = '/work/help/tool/' + a
	end

end

before '/work/task*' do

	@left_menu[:group] = {}
	work_groups = _kv(:work_group, :wgid, :name)
	work_group_user.each do | id |
		@left_menu[:group][work_groups[id].to_sym] = "/work/task/view/#{id.to_s}"
	end

end
