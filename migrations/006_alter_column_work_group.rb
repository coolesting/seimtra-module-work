Sequel.migration do
	change do
		alter_table(:work_group) do
			add_column :wgtid, Integer, :default => 1
		end
	end
end
