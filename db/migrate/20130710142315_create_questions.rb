class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :title
      t.text :answer
      t.integer :thread_id

      t.timestamps
    end
  end
end
