require 'resque/server'

Resque::Server.use(Rack::Auth::Basic) do |email, password|
  email == 'admin@admin.com' && password == 'admin12'
end