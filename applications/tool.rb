get '/work/help/tool/:type' do
	@res = DB[:work_tool].filter(:type => params[:type]).all
	_tpl :work_tool
end

#new a group
get '/work/help/tool/group/new' do
	_tpl :work_tool_group_new
end

post '/work/help/tool/group/new' do
	work_group_set_fields
	work_group_valid_fields
	#new gourp
	DB[:work_group].insert(@fields)
	wgid = DB[:work_group].filter(@fields).get(:wgid)
	#add user to group
	DB[:work_group_user].insert(:uid => _user[:uid], :wgid => wgid, :rule => 2)
	redirect '/work/home/group/list'
end

#join a group by id
get '/work/help/tool/group/join' do
	_tpl :work_tool_group_join
end

post '/work/help/tool/group/join' do
	#the user is whether in this group
	if DB[:work_group_user].filter(:uid => _user[:uid], :wgid => params[:wgid]).get(:wguid)
		_throw L[:'you have been join in this group']
	end

	#sent message to the group owner
	ds = DB[:work_group].filter(:wgid => params[:wgid])
 	group = ds.get(:name)
 	to_uid = ds.get(:uid)
	content = "#{_user[:name]} want to join the #{group} group"
 	_note_send content, _user[:uid], to_uid, 'work_group'
	_msg L[:'the message of joining group has been sent to group owner']
	
	#add the user to group
	DB[:work_group_user].insert(:uid => _user[:uid], :wgid => params[:wgid], :rule => 0)
	redirect "/work/help/tool/group"
end

before '/work/help/tool/*' do
	#puts params[:splat]
end
