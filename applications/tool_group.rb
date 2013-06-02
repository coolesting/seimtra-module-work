#====================
#the list of group
#====================
get '/work/help/tool/group/list' do
	@res = work_group_by_user
	_tpl :work_tool_group_list
end

#user list of group
get '/work/help/tool/group/list/:wgid' do
	@wgid = params[:wgid]
	@res = DB[:work_group_user].filter(:wgid => params[:wgid]).all
	_tpl :work_tool_group_user
end

#quit from group
post '/work/help/tool/group/set' do
	if params[:wgid] and params[:opt]
		if params[:opt] == 'quit'
			params[:wgid].each do | wgid |
				DB[:work_group_user].filter(:uid => _user[:uid], :wgid => wgid).delete
			end
		end
	end
	#send message to the group owner
# 	ds = DB[:work_group].filter(:wgid => params[:id])
# 	to_uid = ds.get(:uid)
# 	group = ds.get(:name)
#  	_note_send "I have quit the #{group} group yet", _user[:uid], to_uid, 'work_group'
	redirect back
end

post '/work/help/tool/group/set_user/:wgid' do
	work_is_group_admin params[:wgid], true

	if params[:wguid] and params[:opt]
		if params[:opt] == 'remove'
			params[:wguid].each do | wguid |
				ds = DB[:work_group_user].filter(:wguid => params[:wguid])
				#send message to the user
				to_uid = ds.get(:uid)
				groups = _kv :work_group, :wgid, :name
				group = groups[ds.get(:wgid)]
				ds.delete
				_note_send "I have quit the #{group} group yet", _user[:uid], to_uid, 'work_group'
			end
		else
			wgurs = _vars :group_user_rule, :work
			params[:wguid].each do | wguid |
				rule = wgurs.index params[:opt]
				if rule != nil
					DB[:work_group_user].filter(:wguid => wguid).update(:rule => rule)
				end
			end
		end
	end

	redirect back
end

#====================
#new a group
#====================
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
	redirect '/work/help/tool/group/list'
end

#====================
#join a group by id
#====================
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

#====================
#merge user groups
#====================
get '/work/help/tool/group/merge' do
	_tpl :work_tool_group_merge
end

post '/work/help/tool/group/merge' do
	#is the admin of the group
	if params[:from_group] and params[:to_group]
		duplicate_record = []
		params[:from_group].delete(params[:to_group])

		params[:from_group].each do | id |
			if work_is_group_admin(id)
				#update the task table
				DB[:work_task].filter(:wgid => id).update(:wgid => params[:to_group])

				#update the group user
				DB[:work_group_user].filter(:wgid => id).update(:wgid => params[:to_group])
				
				#get the duplicate user
				togroup_user = []
				DB[:work_group_user].filter(:wgid => params[:to_group]).each do | row |
					unless togroup_user.include?(row[:uid])
						togroup_user << row[:uid] 
					else
						duplicate_record << row[:wguid]
					end
				end
			end
		end

		#remove the duplicate record
		DB[:work_group_user].where(:wguid => duplicate_record).delete

	end

	#sent message to the group owner
# 	ds = DB[:work_group].filter(:wgid => params[:wgid])
#  	group = ds.get(:name)
#  	to_uid = ds.get(:uid)
# 	content = "#{_user[:name]} want to join the #{group} group"
#  	_note_send content, _user[:uid], to_uid, 'work_group'
# 	_msg L[:'the message of joining group has been sent to group owner']
	
	redirect "/work/help/tool/group"
end
