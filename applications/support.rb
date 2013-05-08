get '/work/help/support/post/:ctid' do
	cms_get_list params[:ctid]
end

get '/work/help/support/post/:ctid/:cpid' do
	cms_get_post params[:cpid]
end

get '/work/help/support/form' do
	cms_form
end

before '/work/help/support*' do
	@cms_route_path = '/work/help/support'
end
