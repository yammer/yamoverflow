class AddQuestionIdToWorkfeedThreads < ActiveRecord::Migration
  def change
    add_column :workfeed_threads, :question_id, :integer
  end
end
