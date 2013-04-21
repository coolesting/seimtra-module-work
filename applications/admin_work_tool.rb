#display
get '/admin/work_tool' do

	@rightbar += [:new, :search]
	ds = DB[:work_tool]

	#search content
	ds = ds.filter(@qs[:sw].to_sym => @qs[:sc]) if @qs[:sw] and @qs[:sc]

	#search condition
	if @rightbar.include? :search
		@search = {:wtid => 'wtid', :type => 'type', :method_name => 'method_name', :name => 'name', :description => 'description', }
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
 	@work_tool = ds.paginate(@page_curr, @page_size, ds.count)
 	@page_count = @work_tool.page_count

	_tpl :admin_work_tool

end

#new a record
get '/admin/work_tool/new' do

	@title = L[:'create a new one '] + L[:'work_tool']
	@rightbar << :save
	work_tool_set_fields
	_tpl :admin_work_tool_form

end

post '/admin/work_tool/new' do

	work_tool_set_fields
	work_tool_valid_fields
	
	
	
	DB[:work_tool].insert(@fields)
	redirect "/admin/work_tool"

end

#delete the record
get '/admin/work_tool/rm/:wtid' do

	_msg L[:'delete the record by id '] + params[:'wtid']
	DB[:work_tool].filter(:wtid => params[:wtid].to_i).delete
	redirect "/admin/work_tool"

end

#edit the record
get '/admin/work_tool/edit/:wtid' do

	@title = L[:'edit the '] + L[:'work_tool']
	@rightbar << :save
	@fields = DB[:work_tool].filter(:wtid => params[:wtid]).all[0]
 	work_tool_set_fields
 	_tpl :admin_work_tool_form

end

post '/admin/work_tool/edit/:wtid' do

	work_tool_set_fields
	work_tool_valid_fields
	
	
	DB[:work_tool].filter(:wtid => params[:wtid]).update(@fields)
	redirect "/admin/work_tool"

end

helpers do

	#fill the @fields with the default value
	#the @fields will be write into database, or display by template to frontground
	def work_tool_set_fields
		
		default_values = {
			:type		=> '',
			:method_name		=> '',
			:name		=> '',
			:description		=> ''
		}

		default_values.each do | k, v |
			unless @fields.include? k
				@fields[k] = params[k] ? params[k] : v
			end
		end

	end

	def work_tool_valid_fields
		
		_throw(L[:'the field cannot be empty '] + L[:'type']) if @fields[:type].strip.size < 1
		
		_throw(L[:'the field cannot be empty '] + L[:'method_name']) if @fields[:method_name].strip.size < 1
		
		_throw(L[:'the field cannot be empty '] + L[:'name']) if @fields[:name].strip.size < 1
		
		_throw(L[:'the field cannot be empty '] + L[:'description']) if @fields[:description].strip.size < 1
		
	end

end
