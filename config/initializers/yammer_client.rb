Yammer.configure do |c|
  c.client_id = ENV['YAMMER_KEY']
  c.client_secret = ENV['YAMMER_SECRET']
end