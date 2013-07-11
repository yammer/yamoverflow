class QuestionsController < ApplicationController
	before_action :set_question, only: [:show, :edit, :update, :destroy]

	before_action :check_if_thread_already_exists, :only => :new

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
		thread_starter = yammer_client.thread_starter(params[:thread_id])
		answer = yammer_client.find_tagged_answer(params[:thread_id])

		@question = Question.new :title => thread_starter, :answer => answer, :thread_id => params[:thread_id]
	end

	def create
		@question = Question.new(question_params)
		answer = yammer_client.find_tagged_answer(params[:question][:thread_id])
		@question.answer = answer[:body]
		@question.answer_id = answer[:id]
		@question.representation = yammer_client.full_thread(params[:question][:thread_id]).to_json
		@question.user_id = current_user.id

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

	def edit
		answer = yammer_client.find_tagged_answer(@question[:thread_id])
		@question.answer = answer[:body]
		@question.answer_id = answer[:id]
	end

	def update
		@question.user_id = current_user.id
		answer = yammer_client.find_tagged_answer(params[:question][:thread_id])
		@question.answer = answer[:body]
		@question.answer_id = answer[:id]
		@question.representation = yammer_client.full_thread(params[:question][:thread_id]).to_json

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
		def find_topics(thread_id)
			topics = yammer_client.topics(thread_id)
			result = Array.new
			topics.each do |t|
				topic = Topic.find_by_workfeed_topic_id(t[:id])
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

    def check_if_thread_already_exists
    	unless (question = Question.find_by_thread_id(params[:thread_id])).blank?
    		redirect_to edit_question_url(question)
    	end
    end
end
