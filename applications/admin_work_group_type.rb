#display
get '/admin/work_group_type' do

	@rightbar += [:new, :search]
	ds = DB[:work_group_type]

	#search content
	ds = ds.filter(@qs[:sw].to_sym => @qs[:sc]) if @qs[:sw] and @qs[:sc]

	#search condition
	if @rightbar.include? :search
		@search = {:wgtid => 'wgtid', :name => 'name', :uid => 'uid', }
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
 	@work_group_type = ds.paginate(@page_curr, @page_size, ds.count)
 	@page_count = @work_group_type.page_count

	_tpl :admin_work_group_type

end

#new a record
get '/admin/work_group_type/new' do

	@title = L[:'create a new one '] + L[:'work_group_type']
	@rightbar << :save
	work_group_type_set_fields
	_tpl :admin_work_group_type_form

end

post '/admin/work_group_type/new' do

	work_group_type_set_fields
	work_group_type_valid_fields
	
	
	
	DB[:work_group_type].insert(@fields)
	redirect "/admin/work_group_type"

end

#delete the record
get '/admin/work_group_type/rm/:wgtid' do

	_msg L[:'delete the record by id '] + params[:'wgtid']
	DB[:work_group_type].filter(:wgtid => params[:wgtid].to_i).delete
	redirect "/admin/work_group_type"

end

#edit the record
get '/admin/work_group_type/edit/:wgtid' do

	@title = L[:'edit the '] + L[:'work_group_type']
	@rightbar << :save
	@fields = DB[:work_group_type].filter(:wgtid => params[:wgtid]).all[0]
 	work_group_type_set_fields
 	_tpl :admin_work_group_type_form

end

post '/admin/work_group_type/edit/:wgtid' do

	work_group_type_set_fields
	work_group_type_valid_fields
	
	
	DB[:work_group_type].filter(:wgtid => params[:wgtid]).update(@fields)
	redirect "/admin/work_group_type"

end

helpers do

	#fill the @fields with the default value
	#the @fields will be write into database, or display by template to frontground
	def work_group_type_set_fields
		
		default_values = {
			:name		=> '',
			:uid		=> _user[:uid]
		}

		default_values.each do | k, v |
			unless @fields.include? k
				@fields[k] = params[k] ? params[k] : v
			end
		end

	end

	def work_group_type_valid_fields
		
		_throw(L[:'the field cannot be empty '] + L[:'name']) if @fields[:name].strip.size < 1
		
		#_throw(L[:'the field cannot be empty '] + L[:'uid']) if @fields[:uid] != 0
		
	end

end
