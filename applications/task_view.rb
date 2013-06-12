#display the task by multiple forms of view
get '/work/task' do
	@qs[:y] = Time.now.year unless @qs.include?(:y)
	@qs[:m] = Time.now.mon unless @qs.include?(:m)
	@qs[:d] = Time.now.day unless @qs.include?(:d)
	unless @qs.include?(:w)
		require 'week_of_month'
		@qs[:w] = Time.now.week_of_month
	end
	if @qs[:vt] == 'l'
		work_task_view_list
	elsif @qs[:vt] == 'y'
		work_task_view_year
	elsif @qs[:vt] == 'm'
		work_task_view_month
	elsif @qs[:vt] == 'w'
		work_task_view_week
	elsif @qs[:vt] == 'd'
		work_task_view_day
	end
end

helpers do

	#year form
	def work_task_view_year
		@res = {}
		12.times do | i |
			i = i + 1
			@res[i] = i.to_s
		end

		_tpl :work_task_year, :work_layout3
	end

	#month form
	def work_task_view_month
		@res = {}
		6.times do | i |
			i = i + 1
			@res[i] = i.to_s
		end

		_tpl :work_task_month, :work_layout3
	end

	#day form
	def work_task_view_day
		newtime = Time.new(@qs[:y].to_i,@qs[:m].to_i,1)
		wday = newtime.wday - 1
		mday = newtime.mday

		require 'date'
		days = Date.new(@qs[:y].to_i,@qs[:m].to_i,-1).day + wday + 1

		@res = {}
		42.times do | i |
			if i > wday and i < days
				day = i - wday
				@res[i] = day.to_s
			else
				@res[i] = '' 
			end
		end

		_tpl :work_task_day, :work_layout3
	end

	#week form
	def  work_task_view_week
		@res = {
			7	=> :Sun,
			1	=> :Mon,
			2 	=> :Tue,
			3	=> :Wed,
			4	=> :Thu,
			5	=> :Fri,
			6	=> :Sat,
		}

		_tpl :work_task_week, :work_layout3
	end

	#list form
	def work_task_view_list
		condition = {}

		#status
		condition[:status] = @qs.include?(:status) ? @qs[:status].to_i : 0

		#work group
		if @qs.include?(:wgid) and @qs[:wgid].to_i > 0
			condition[:wgid] = @qs[:wgid] 
		else
			condition[:uid] = _user[:uid] 
		end

		@task = DB[:work_task].filter(condition).reverse_order(:changed)
		_parser_init :no_intra_emphasis => true
		_tpl :work_task_list, :work_layout3
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

