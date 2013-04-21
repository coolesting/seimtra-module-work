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
