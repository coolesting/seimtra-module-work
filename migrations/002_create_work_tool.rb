Sequel.migration do
	change do
		create_table(:work_tool) do
			primary_key :wtid
			String :type
			String :method_name
			String :name
			String :description
		end
	end
end
