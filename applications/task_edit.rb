
get '/work/task/edit' do
	@fields = DB[:work_task].filter(:wtid => params[:wtid]).all[0] if @qs.include? :wtid
	work_task_set_fields
	_tpl :work_task_form, :work_layout3
end

#edit task, if the task is not existing, create new.
post '/work/task/edit' do
	work_task_set_fields
	work_task_valid_fields
	@fields[:changed] = Time.now

	route_path = '/work/task'
	if params[:wtid]
		#fetch the content field and compare it
		ds = DB[:work_task].filter(:wtid => params[:wtid])

		#if the content is not same, log it
		unless ds.get(:content) == @fields[:content]
			#_log :work_task, @fields[:content], @fields[:wtid]
		end

		#update the content
		@fields[:changed_count] = ds.get(:changed_count).to_i + 1
		ds.update(@fields)
	else
  		@fields[:created] = Time.now
  		DB[:work_task].insert(@fields)
	end
	redirect _url(route_path, @qs)
end

#edit the status of task
get '/work/edit/status/:id' do
	fields = {}
	fields[:changed] = Time.now
	fields[:status] = params[:id]
	DB[:work_task].filter(:wtid => @qs[:wtid]).update(fields) if @qs.include? :wtid
	redirect back
end
