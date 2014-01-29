set :app_path,"#{application}"
set :rails_env, "local"

ssh_options[:port] = 22
role :web, "coachcrm.local"                         # Your HTTP server, Apache/etc
role :db, "coachcrm.local",:primary=>true 
release= ENV['RELEASE'] || nil

unless release.nil?
  set :branch,release
end
