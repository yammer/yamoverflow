class DropWorkfeedThread < ActiveRecord::Migration
  def change
  	drop_table :workfeed_threads
  end
end
