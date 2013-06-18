
configure do
	set :home_page, '/work/task'
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
end

before '/work/help*' do

	@left_menu = {
		:document => {
			:suggestion => '/work/help/docs/post/1',
			:report		=> '/work/help/docs/post/2',
			:decision	=> '/work/help/docs/post/3',
		},
# 		:base => {
# 			:info	=> '/work/home/settings/info',
# 			:contact=> '/work/home/settings/contact',
# 			:secure	=> '/work/home/settings/secure',
# 			:messages => '/work/help/message/group',
# 		},
		:tool => {},
	}
	_vars(:tool_type, :work).each do | a |
		@left_menu[:tool][a.to_sym] = '/work/help/tool/' + a
	end

end

before '/work/task*' do
	@task_group = work_group_by_user
	@left_menu 	= work_group_with_type
	#if no group belong to current user, create a default group ?

	#define the data construct
	@top_menu1 = {
		:wgid	=> {},
		:status => {},
		:vt 	=> {
			:y 	=> 'year',
			:m	=> 'month',
			:w	=> 'week',
			:d	=> 'day',
			:l	=> 'list',
		},
	}

	@top_menu2 = {
		:y	=> {
			:y => {}
		},
		:m	=> {
			:m => {}
		},
		:d	=> {
			:m => {},
			:sp => '|',
			:y => {},
		},
		:w	=> {
			:w => {},
		},
		:l	=> {
			:l => {},
		},
	}
	#year
	y = Time.now.year
	[y, y + 1, y + 2].each do | i |
		@top_menu2[:y][:y][i] = i
	end

	#week
	6.times do | i |
		i = i + 1
		@top_menu2[:w][:w][i] = i
	end

	#day
	12.times do | i |
		i = i + 1
		@top_menu2[:d][:m][i] = i
		#month
		@top_menu2[:m][:m][i] = i
	end
	[y, y + 1].each do | i |
		@top_menu2[:d][:y][i] = i
	end

	status = _vars :task_status, :work
	status.each_index do | i |
		@top_menu1[:status][i] = status[i]
	end

	groups = _kv(:work_group, :wgid, :name)
	@task_group.each do | i |
		@top_menu1[:wgid][i] = groups[i]
	end

	#set the default value of @qs
	@qs[:vt] = 'l' unless @qs.include? :vt
	@qs[:status] = 0 unless @qs.include? :status

end
