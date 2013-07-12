class Question < ActiveRecord::Base
	has_and_belongs_to_many :topics
	belongs_to :user

	def self.query(q)
  	q = "%#{q}%"
		where("title ILIKE ? or answer ILIKE ?",q,q)
	end
end
