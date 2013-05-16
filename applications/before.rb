
configure do
	set :home_page, '/work/home'
end

before '/work/*' do
	@title = "Cloud workstation"

	@work_menu = {
		:home => '/work/home',
		:task => '/work/task',
		:help => '/work/help',
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
		:advanced => {},
	}
	_vars(:work_tool_type).each do | a |
		@left_menu[:advanced][a.to_sym] = '/work/home/tool/' + a
	end
end

before '/work/help*' do

	@left_menu = {
		:document => {
			:suggestion => '/work/help/docs/post/1',
			:report		=> '/work/help/docs/post/2',
			:decision	=> '/work/help/docs/post/3',
		}
	}

end

before '/work/task*' do
	@task_group = work_group_user
	@task_type = {
		:year => '/work/task/year',
		:month => '/work/task/month',
		:week => '/work/task/week',
		:group => '/work/task/group',
		:edit => '/work/task/edit'
	}
end
