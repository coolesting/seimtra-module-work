#display
get '/admin/work_group_user' do

	@rightbar += [:new, :search]
	ds = DB[:work_group_user]

	#search content
	ds = ds.filter(@qs[:sw].to_sym => @qs[:sc]) if @qs[:sw] and @qs[:sc]

	#search condition
	if @rightbar.include? :search
		@search = {:wguid => 'wguid', :uid => 'uid', :wgid => 'wgid', :rule => 'rule'}
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
 	@work_group_user = ds.paginate(@page_curr, @page_size, ds.count)
 	@page_count = @work_group_user.page_count

	_tpl :admin_work_group_user

end

#new a record
get '/admin/work_group_user/new' do

	@title = L[:'create a new one '] + L[:'record']
	@rightbar << :save
	work_group_user_set_fields
	_tpl :admin_work_group_user_form

end

post '/admin/work_group_user/new' do

	work_group_user_set_fields
	work_group_user_valid_fields
	DB[:work_group_user].insert(@fields)
	redirect "/admin/work_group_user"

end

#delete the record
get '/admin/work_group_user/rm/:wguid' do

	_msg L[:'delete the record by id '] + params[:'wguid']
	DB[:work_group_user].filter(:wguid => params[:wguid].to_i).delete
	redirect "/admin/work_group_user"

end

#edit the record
get '/admin/work_group_user/edit/:wguid' do

	@title = L[:'edit the '] + L[:'group user record']
	@rightbar << :save
	@fields = DB[:work_group_user].filter(:wguid => params[:wguid]).all[0]
 	work_group_user_set_fields
 	_tpl :admin_work_group_user_form

end

post '/admin/work_group_user/edit/:wguid' do

	work_group_user_set_fields
	work_group_user_valid_fields
	DB[:work_group_user].filter(:wguid => params[:wguid]).update(@fields)
	redirect "/admin/work_group_user"

end

helpers do

	#fill the @fields with the default value
	#the @fields will be write into database, or display by template to frontground
	def work_group_user_set_fields
		
		default_values = {
			:uid		=> _user[:uid],
			:wgid		=> 0,
			:rule		=> 0
		}

		default_values.each do | k, v |
			unless @fields.include? k
				@fields[k] = params[k] ? params[k] : v
			end
		end

	end

	def work_group_user_valid_fields
		
		#_throw(L[:'the field cannot be empty '] + L[:'uid']) if @fields[:uid] != 0
		
		#_throw(L[:'the field cannot be empty '] + L[:'wgid']) if @fields[:wgid] != 0
		
		#_throw(L[:'the field cannot be empty '] + L[:'rule']) if @fields[:rule] != 0
		
	end

end
