#display
get '/admin/work_task' do

	@rightbar += [:new, :search]
	ds = DB[:work_task]

	#search content
	ds = ds.filter(@qs[:sw].to_sym => @qs[:sc]) if @qs[:sw] and @qs[:sc]

	#search condition
	if @rightbar.include? :search
		@search = {:wtid => 'wtid', :uid => 'uid', :status => 'status', :wgid => 'name', :created => 'created', :changed => 'changed', :content => 'content', }
	end

	#order
	if @qs[:order]
		if @qs.has_key? :desc
			ds = ds.reverse_order(@qs[:order].to_sym)
			@qs.delete :desc
		else
			ds = ds.order(@qs[:order].to_sym)
			@qs[:desc] = 'yes'
		end
	end

	Sequel.extension :pagination
 	@work_task = ds.paginate(@page_curr, @page_size, ds.count)
 	@page_count = @work_task.page_count

	_tpl :admin_work_task

end

#new a record
get '/admin/work_task/new' do

	@title = 'Create a new work_task'
	@rightbar << :save
	work_task_set_fields
	_tpl :admin_work_task_form

end

post '/admin/work_task/new' do

	work_task_set_fields
	work_task_valid_fields
	@fields[:created] = Time.now
	@fields[:changed] = Time.now
	DB[:work_task].insert(@fields)
	redirect "/admin/work_task"

end

#delete the record
get '/admin/work_task/rm/:wtid' do

	_msg 'Delete the work_task by id wtid.'
	DB[:work_task].filter(:wtid => params[:wtid].to_i).delete
	redirect "/admin/work_task"

end

#edit the record
get '/admin/work_task/edit/:wtid' do

	@title = 'Edit the work_task'
	@rightbar << :save
	@fields = DB[:work_task].filter(:wtid => params[:wtid]).all[0]
 	work_task_set_fields
 	_tpl :admin_work_task_form

end

post '/admin/work_task/edit/:wtid' do

	work_task_set_fields
	work_task_valid_fields
	@fields[:changed] = Time.now
	DB[:work_task].filter(:wtid => params[:wtid]).update(@fields)
	redirect "/admin/work_task"

end

helpers do

	#fill the @fields with the default value
	#the @fields will be write into database, or display by template to frontground
	def work_task_set_fields
		
		default_values = {
			:uid		=> _user[:uid],
			:status		=> 0,
			:wgid		=> 1,
			:content	=> ''
		}

		default_values.each do | k, v |
			unless @fields.include? k
				@fields[k] = params[k] ? params[k] : v
			end
		end

	end

	def work_task_valid_fields
		
		#_throw "The uid field cannot be empty." if @fields[:uid] != 0
		
		field = _vars :task_status
		_throw "The status field isn't existing." if field[@fields[:status].to_i] == nil

		field = _kv :work_group, :wgid, :name
		_throw "The wgid field isn't existing." unless field.include? @fields[:wgid].to_i

		_throw "The content field cannot be empty." if @fields[:content].strip.size < 1
		
	end

end
