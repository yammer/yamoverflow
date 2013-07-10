class AddThreadsInfoToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :representation, :text
  end
end
