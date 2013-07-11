class QuestionsController < ApplicationController
	before_action :set_question, only: [:show, :edit, :update, :destroy]

	def index
		if params[:topic].blank?
    	@questions = Question.all
    else
    	topic = Topic.find(params[:topic])
    	@questions = topic.questions
    end
    @topics = Topic.all
  end

	def new
		thread_starter = yammer_thread_starter(params[:thread_id])
		answer = find_tagged_answer(params[:thread_id])

		@question = Question.new :title => thread_starter, :answer => answer, :thread_id => params[:thread_id]
	end

	def create
		@question = Question.new(question_params)
		@question.answer = find_tagged_answer(params[:question][:thread_id])
		@question.representation = yammer_full_thread(params[:question][:thread_id]).to_json

		@question.topics = find_topics(params[:question][:thread_id])

		respond_to do |format|
      if @question.save
        format.html { redirect_to @question, notice: 'Question was successfully created.' }
        format.json { render action: 'show', status: :created, location: @question }
      else
        format.html { render action: 'new' }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
	end

	def update
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to @question, notice: 'Question was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @question.destroy
    respond_to do |format|
      format.html { redirect_to questions_url }
      format.json { head :no_content }
    end
  end



	private
		def yammer_thread_starter(thread_id)
			message = yammer_client.get_message(thread_id)
			message.body[:body][:plain]
		end

		def yammer_full_thread(thread_id)
			messages = yammer_client.messages_in_thread(thread_id)
			messages.body
		end

		def find_tagged_answer(thread_id)
			messages = yammer_client.messages_in_thread(thread_id)
			messages = messages.body[:messages]

			messages = messages.select do |message|
				message[:thread_id] != message[:id] && message[:body][:plain].match("#yamoverflow")
			end

			messages.sort_by! {|msg| msg[:id]}
			messages.last[:body][:plain]
		end

		def topics(thread_id)
			topics = []
			thread = yammer_client.get_thread(thread_id)
			thread = thread.body
			thread[:references].each do |reference|
				if reference[:type] == "topic" && reference[:name] != "Yamoverflow"
					topics << reference
				end
			end

			topics
		end

		def find_topics(thread_id)
			topics = topics(thread_id)
			result = Array.new
			topics.each do |t|
				topic = Topic.find_by_id(t[:id])
				if topic.nil?
					topic = Topic.create! :workfeed_topic_id => t[:id], :name => t[:name]
				end
				result << topic
			end
			result
		end

    def set_question
      @question = Question.find(params[:id])
    end

    def question_params
      params.require(:question).permit(:title,:thread_id)
    end
end
