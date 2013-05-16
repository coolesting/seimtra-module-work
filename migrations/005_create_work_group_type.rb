Sequel.migration do
	change do
		create_table(:work_group_type) do
			primary_key :wgtid
			Integer :uid
			String :name
		end
	end
end
