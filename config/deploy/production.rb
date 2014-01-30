set :app_path ,"#{application}"
set :rails_env, "production"

role :web, "www.crm.mtbcoach.com"                         # Your HTTP server, Apache/etc
role :db, "www.crm.mtbcoach.com",:primary=>true 

release= ENV['RELEASE'] || nil

unless release.nil?
  set :branch, release
else
  raise Capistrano::Error, "Missing release parameter, append RELEASE=N.NN or branch_name to deploy command. EXAMPLE: cap production deploy RELEASE=1.00"
end