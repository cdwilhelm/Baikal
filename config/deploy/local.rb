set :app_path,"#{application}"
set :deploy_to, "/var/www/#{app_path}"
set :rails_env, "local"
set :pub_server_name, 'calendar.local'
set :db_name,'staging'
ssh_options[:port] = 22
role :web, "coachcrm.local"                         # Your HTTP server, Apache/etc
role :db, "coachcrm.local",:primary=>true 
release= ENV['RELEASE'] || nil

unless release.nil?
  set :branch,release
end
