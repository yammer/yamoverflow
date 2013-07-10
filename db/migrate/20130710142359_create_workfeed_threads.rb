class CreateWorkfeedThreads < ActiveRecord::Migration
  def change
    create_table :workfeed_threads do |t|
      t.integer :workfeed_id
      t.text :representation

      t.timestamps
    end
  end
end
