require File.dirname(__FILE__) + "/../yammer_client.rb"

desc "Update questions with latest answer"
task :update_questions  => :environment do
	n_questions = Question.all.count
	puts "Updating #{n_questions} questions"
	i = 0
  Question.all.each do |question|
  	i += 1
  	puts "Updating ##{question.id} - #{i}/#{n_questions}..."
  	client = YammerClient.new(User.find(question.user_id).auth_token)
  	answer = client.find_tagged_answer(question.thread_id)

  	if question.answer_id != answer[:id]
  		question.answer_id = answer[:id]
  		question.answer = answer[:body]
  	end	

  	question.representation = client.full_thread(question.thread_id).to_json
  	question.save
  	puts "Done"
  	sleep 5
  end
  puts "DONE"
end