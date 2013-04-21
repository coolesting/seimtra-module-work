#display the task
get '/work/task' do
	work_task_view
end

get '/work/task/view/:wgid' do
	work_task_view
end

#edit task
get '/work/task/edit' do

	@fields = DB[:work_task].filter(:wtid => params[:wtid]).all[0] if @qs.include? :wtid
	work_task_set_fields
	_tpl :work_task_form

end

#edit task, if the task is not existing, create new.
post '/work/task/edit' do

	work_task_set_fields
	work_task_valid_fields
	@fields[:changed] = Time.now

	route_path = '/work/task/view/0'
	if params[:wtid]
		DB[:work_task].filter(:wtid => params[:wtid]).update(@fields)
		redirect _url(route_path, @qs)
	else
  		@fields[:created] = Time.now
  		DB[:work_task].insert(@fields)
		redirect _url(route_path, @qs)
	end

end

#edit the status of task
get '/work/edit/status/:id' do
	fields = {}
	fields[:changed] = Time.now
	fields[:status] = params[:id]
	DB[:work_task].filter(:wtid => @qs[:wtid]).update(fields) if @qs.include? :wtid
	redirect back
end

helpers do

	def work_task_view
		#status
		condition = {}
		@qs[:status] = 0 unless (@qs.include?(:status) and @qs[:status].to_i > 0)
		condition[:status] = @qs[:status]

		#group
		if params[:wgid] and params[:wgid].to_i > 0
			condition[:wgid] = params[:wgid] 
		else
			condition[:uid] = _user[:uid] 
		end

		@task = DB[:work_task].filter(condition).reverse_order(:changed)
		_parser_init :no_intra_emphasis => true
		_tpl :work_task
	end

end
