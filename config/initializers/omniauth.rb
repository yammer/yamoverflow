Rails.application.config.middleware.use OmniAuth::Builder do
	provider :yammer, ENV['YAMMER_KEY'], ENV['YAMMER_SECRET']
end

OmniAuth.config.logger = Rails.logger