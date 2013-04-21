get '/admin/work' do
	_tpl :_default
end

get '/work/login' do
	@res = _docs 1
	_tpl :work_login, :work_login_layout
end

get '/work/home' do
	_tpl :work_home
end
