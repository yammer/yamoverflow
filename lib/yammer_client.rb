# Copyright (c) Microsoft Corporation
# All rights reserved.
# Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# THIS CODE IS PROVIDED *AS IS* BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION ANY IMPLIED WARRANTIES OR CONDITIONS OF TITLE, FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABLITY OR NON-INFRINGEMENT. 
#
# See the Apache Version 2.0 License for specific language governing permissions and limitations under the License. 
#
class YammerClient
	attr_reader :yammer_client

	def initialize(access_token)
		@yammer_client = Yammer::Client.new(:access_token  => access_token)
	end

	def thread_starter(thread_id)
		message = @yammer_client.get_message(thread_id)
		message.body[:body][:plain]
	end

	def full_thread(thread_id)
		messages = @yammer_client.messages_in_thread(thread_id)
		messages.body
	end

	def find_tagged_answer(thread_id)
		messages = @yammer_client.messages_in_thread(thread_id)
		messages = messages.body[:messages]

		messages = messages.select do |message|
			message[:thread_id] != message[:id] && message[:body][:plain].match("#yamoverflow")
		end

		messages.sort_by! {|msg| msg[:id]}
		answer = messages.last
		raise "You need at least one reply tagged with #yamoverflow" if answer.blank?
		answer[:body][:plain].gsub!("#yamoverflow","")
		{:id => answer[:id], :body => answer[:body][:plain]}
	end

	def topics(thread_id)
		topics = []
		thread = @yammer_client.get_thread(thread_id)
		thread = thread.body
		thread[:references].each do |reference|
			if reference[:type] == "topic" && reference[:name] != "Yamoverflow"
				topics << reference
			end
		end

		topics
	end
end
