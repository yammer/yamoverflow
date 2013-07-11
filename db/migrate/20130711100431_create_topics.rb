class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.integer :workfeed_topic_id
      t.text :name
      t.integer :questions_count

      t.timestamps
    end
  end
end
