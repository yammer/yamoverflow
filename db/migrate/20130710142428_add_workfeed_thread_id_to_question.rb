class AddWorkfeedThreadIdToQuestion < ActiveRecord::Migration
  def change
  	add_column :questions,:workfeed_thread_id, :integer
  end
end
