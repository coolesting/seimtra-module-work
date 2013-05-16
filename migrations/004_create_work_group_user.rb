Sequel.migration do
	change do
		create_table(:work_group_user) do
			primary_key :wguid
			Integer :uid
			Integer :wgid
			Integer :rule, :default => 0
		end
	end
end
