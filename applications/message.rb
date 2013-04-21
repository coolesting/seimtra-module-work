#display message from group
get '/work/home/message/group' do
	@res = _note 'work_group', _user[:uid] 
	_tpl :work_home_message_group
end

#display message from user
get '/work/home/message/user' do
	@my_msg = _note 'work_user', _user[:uid] 
	_tpl :work_home_message_user
end

get '/work/home/message/cleanall' do
	_note_all
	redirect back
end

#remove message
post '/work/home/message/set' do
	if params[:nids] and params[:opt]
		if params[:opt] == 'remove'
			params[:nids].each do | nid |
				_note_rm nid
			end
		end
	end
	redirect back
end
