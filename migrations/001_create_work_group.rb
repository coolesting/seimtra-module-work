Sequel.migration do
	change do
		create_table(:work_group) do
			primary_key :wgid
			String :name
			String :description
			Integer :uid
			Integer :wgtid, :default => 1
			Integer :level, :default => 1
		end
	end
end
