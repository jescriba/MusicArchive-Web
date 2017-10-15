Resque::Server.use(Rack::Auth::Basic) do |username, password|
  username == ENV["USERNAME"] and password == ENV["PASSWORD"]
end
