
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
		:base => {
			#:info	=> '/work/home/settings/info',
			#:contact=> '/work/home/settings/contact',
			#:secure	=> '/work/home/settings/secure',
			:group	=> '/work/home/group/list',
			:messages => '/work/home/message/group',
		},
		:advanced => {}
# 		:messages	=> {
# 			:group	=> '/work/home/message/group',
# 			:user	=> '/work/home/message/user',
# 		},
	}
	_vars(:work_tool_type).each do | a |
		@left_menu[:advanced][a.to_sym] = '/work/home/tool/' + a
	end

end

before '/work/help*' do

	@left_menu = {
		:document	=> {
			:faq	=> '/work/help/docs/post/4',
		},
		:support	=> {
			:suggestion => '/work/help/support/post/1',
			:report	=> '/work/help/support/post/2',
			:decision	=> '/work/help/support/post/3',
		}
	}

end

before '/work/task*' do
	@left_menu = work_group_by_type
end
