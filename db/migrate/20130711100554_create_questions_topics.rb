class CreateQuestionsTopics < ActiveRecord::Migration
  def change
    create_table :questions_topics do |t|
      t.integer :question_id
      t.integer :topic_id
    end
  end
end
