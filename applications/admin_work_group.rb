#display
get '/admin/work_group' do

	@rightbar += [:new, :search]
	ds = DB[:work_group]

	#search content
	ds = ds.filter(@qs[:sw].to_sym => @qs[:sc]) if @qs[:sw] and @qs[:sc]

	#search condition
	if @rightbar.include? :search
		@search = {:wgid => 'wgid', :name => 'name', :description => 'description', :uid => 'uid', :wgtid => 'wgtid' }
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
 	@work_group = ds.paginate(@page_curr, @page_size, ds.count)
 	@page_count = @work_group.page_count

	_tpl :admin_work_group

end

#new a record
get '/admin/work_group/new' do

	@title = 'Create a new work_group'
	@rightbar << :save
	work_group_set_fields
	_tpl :admin_work_group_form

end

post '/admin/work_group/new' do

	work_group_set_fields
	work_group_valid_fields
	DB[:work_group].insert(@fields)
	redirect "/admin/work_group"

end

#delete the record
get '/admin/work_group/rm/:wgid' do

	_msg 'Delete the work_group by id wgid.'
	DB[:work_group].filter(:wgid => params[:wgid].to_i).delete
	redirect "/admin/work_group"

end

#edit the record
get '/admin/work_group/edit/:wgid' do

	@title = 'Edit the work_group'
	@rightbar << :save
	@fields = DB[:work_group].filter(:wgid => params[:wgid]).all[0]
 	work_group_set_fields
 	_tpl :admin_work_group_form

end

post '/admin/work_group/edit/:wgid' do

	work_group_set_fields
	work_group_valid_fields
	
	
	DB[:work_group].filter(:wgid => params[:wgid]).update(@fields)
	redirect "/admin/work_group"

end

helpers do

	#fill the @fields with the default value
	#the @fields will be write into database, or display by template to frontground
	def work_group_set_fields
		
		default_values = {
			:name		=> '',
			:description=> '',
			:wgtid		=> 1,
			:uid		=> _user[:uid]
		}

		default_values.each do | k, v |
			unless @fields.include? k
				@fields[k] = params[k] ? params[k] : v
			end
		end

	end

	def work_group_valid_fields
		
		_throw "The name field cannot be empty." if @fields[:name].strip.size < 1
		#_throw "The uid field cannot be empty." if @fields[:uid] != 0
		
	end

end
