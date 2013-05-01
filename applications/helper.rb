helpers do

	#return the groud id by uid
	def work_group_user uid = 0
		res = []
		uid = _user[:uid] if uid == 0
		DB[:work_group_user].filter(:uid => uid.to_i).all.each do | row |
			res << row[:wgid] if row[:rule] > 0
		end
		res
	end

	#get the group by type with current user id
	#return a hash
	def work_group_by_type
		res = {}

		work_groups = _kv(:work_group, :wgid, :wgtid)
		work_group_names = _kv(:work_group, :wgid, :name)
		work_group_types = _kv :work_group_type, :wgtid, :name
		user_group = work_group_user

		user_group.each do | id |
			group_type = work_group_types[work_groups[id]].to_sym
			res[group_type] = {} unless res.include? group_type
			res[group_type][work_group_names[id].to_sym] = "/work/task/view/#{id.to_s}"
		end
		res
	end

	#return true, if the current is group administrator
	def work_is_group_admin wgid, isredirect = false
		if DB[:work_group_user].filter(:uid => _user[:uid], :wgid => wgid).get(:rule) > 1
			true
		else
			if isredirect
				_throw L[:'you are not the administrator of this group']
			else
				false
			end
		end
	end

end
