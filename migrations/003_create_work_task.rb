Sequel.migration do
	change do
		create_table(:work_task) do
			primary_key :wtid
			Integer :uid
			Integer :status
			Integer :wgid
			Datetime :created
			Datetime :changed
			String :username
			Text :content
		end
	end
end
