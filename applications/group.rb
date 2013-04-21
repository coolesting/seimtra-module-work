#the list of group
get '/work/home/group/list' do
	@res = work_group_user
	_tpl :work_home_group_list
end

#user list of group
get '/work/home/group/list/:wgid' do
	@wgid = params[:wgid]
	@res = DB[:work_group_user].filter(:wgid => params[:wgid]).all
	_tpl :work_group_user
end

#quit from group
post '/work/home/group/set' do
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

post '/work/home/group/set_user/:wgid' do
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
			wgurs = _vars(:work_group_user_rule)
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
