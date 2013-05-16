#edit task
get '/work/task/edit' do
	@fields = DB[:work_task].filter(:wtid => params[:wtid]).all[0] if @qs.include? :wtid
	work_task_set_fields
	_tpl :work_task_form, :work_task_layout
end

#edit task, if the task is not existing, create new.
post '/work/task/edit' do
	work_task_set_fields
	work_task_valid_fields
	@fields[:changed] = Time.now

	route_path = '/work/task/group'
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
