# Copyright (c) Microsoft Corporation
# All rights reserved.
# Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# THIS CODE IS PROVIDED *AS IS* BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION ANY IMPLIED WARRANTIES OR CONDITIONS OF TITLE, FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABLITY OR NON-INFRINGEMENT. 
#
# See the Apache Version 2.0 License for specific language governing permissions and limitations under the License. 
#
require File.dirname(__FILE__) + "/../yammer_client.rb"

desc "Update questions with latest answer"
task :update_questions  => :environment do
	n_questions = Question.all.count
	puts "Updating #{n_questions} questions"
	i = 0
  Question.all.each do |question|
  	i += 1
  	begin
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
	  	puts "Going to sleep for 5 seconds..."
	  	sleep 5
	  rescue Exception => ex
	  	Rails.logger.error "There was an error in updating question ##{question.id}"
	  	Rails.logger.error "#{ex.backtrace}"
	  end
  end
  puts "DONE"
end
