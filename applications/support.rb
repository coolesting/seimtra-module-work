get '/work/home/support/post/:ctid' do
	cms_get_list params[:ctid]
end

get '/work/home/support/post/:ctid/:cpid' do
	cms_get_post params[:cpid]
end

get '/work/home/support/form' do
	cms_form
end

before '/work/home/support*' do
	@cms_route_path = '/work/home/support'
end
