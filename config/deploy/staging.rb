set :app_path , "#{application}-staging"
set :rails_env, "staging"

role :web, "www.crm.mtbcoach.com"                         # Your HTTP server, Apache/etc
role :db, "www.crm.mtbcoach.com",:primary=>true 
release= ENV['RELEASE'] || nil

unless release.nil?
  set :branch,release
end
