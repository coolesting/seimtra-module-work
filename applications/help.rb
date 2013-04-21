get '/work/help' do
	_tpl :work_help
end

get '/work/help/docs/post/:ctid' do
	cms_get_list params[:ctid]
end

get '/work/help/docs/post/:ctid/:cpid' do
	cms_get_post params[:cpid]
end

get '/work/help/docs/form' do
	cms_form
end

before '/work/help/docs*' do
	@cms_route_path = '/work/help/docs'
end
