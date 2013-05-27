get '/work/help/tool/:type' do
	@res = DB[:work_tool].filter(:type => params[:type]).all
	_tpl :work_tool
end

before '/work/help/tool/*' do
	#puts params[:splat]
end

