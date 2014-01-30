set :app_path , "#{application}-staging"
set :rails_env, "staging"

set :pub_server_name, 'calt.crm.mtbcoach.com'

role :web, "www.crm.mtbcoach.com"                         # Your HTTP server, Apache/etc
role :db, "www.crm.mtbcoach.com",:primary=>true 
release= ENV['RELEASE'] || nil

unless release.nil?
  set :branch,release
end
