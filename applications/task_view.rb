#default form for display the task list
get '/work/task' do
	work_task_group
end

get '/work/task/group' do
	work_task_group
end

get '/work/task/year' do
	@years = [2013, 2014, 2015]
	@res = {}
	m = @qs.include?(:m) ? @qs[:m].to_i : Time.now.mon
	12.times do | i |
		i = i + 1
		@res[i] = i.to_s
		@res[i] += ' month' if i == m
	end

	_tpl :work_task_year, :work_task_layout
end

get '/work/task/month' do
	@days = {}
	@qs[:y] = Time.now.year unless @qs.include?(:y)
	@qs[:m] = Time.now.mon unless @qs.include?(:m)
	@qs[:d] = Time.now.day unless @qs.include?(:d)
	newtime = Time.new(@qs[:y].to_i,@qs[:m].to_i,1)
	wday = newtime.wday - 1
	mday = newtime.mday

	require 'date'
	days = Date.new(@qs[:y].to_i,@qs[:m].to_i,-1).day + wday + 1

	35.times do | i |
		if i > wday and i < days
			day = i - wday
			@days[i] = day.to_s
		else
			@days[i] = '' 
		end
	end

	_tpl :work_task_month, :work_task_layout
end

get '/work/task/week' do
	@res = {}
	w = @qs.include?(:w) ? @qs[:w].to_i : Time.now.wday
	14.times do | i |
		i = i + 1
		@res[i] = i > 7 ? 'night' : 'day'
		#@res[i] += ' day' if i == w
	end

	_tpl :work_task_week, :work_task_layout
end

helpers do

	#display by group
	def work_task_group
		condition = {}

		#status
		condition[:status] = @qs.include?(:status) ? @qs[:status].to_i : 0

		#group
		if @qs.include?(:wgid) and @qs[:wgid].to_i > 0
			condition[:wgid] = @qs[:wgid] 
		else
			condition[:uid] = _user[:uid] 
		end

		@task = DB[:work_task].filter(condition).reverse_order(:changed)
		_parser_init :no_intra_emphasis => true
		_tpl :work_task_group, :work_task_layout
	end

	def work_get_task_by_user uid = 0
		uid = _user[:uid] if uid == 0 
		res = []
		y = Time.now.year
		m = Time.now.mon
		d = Time.now.day
		ds = DB[:work_task].where{Sequel.&({:uid => uid}, (startime > Time.new(y,m,d).to_i))}.all
		unless ds.empty?
			_parser_init :no_intra_emphasis => true
			res = ds
		end
		res
	end

end

