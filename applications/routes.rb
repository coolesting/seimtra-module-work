get '/admin/work' do
	_tpl :_default
end

get '/work/login' do
	@res = _docs 1
	_tpl :work_login, :work_layout2
end

get '/work/home' do
	@res = work_get_task_by_user
	_tpl :work_home
end

