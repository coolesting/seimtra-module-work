Sequel.migration do
	change do
		create_table(:work_task) do
			primary_key :wtid
			Integer :uid
			Integer :status
			Integer :wgid
			Integer :dtype
			Integer :comment_count, :default => 0
			Integer :startime, :size => 10
			Datetime :created
			Datetime :changed
			Text :content
		end
	end
end
