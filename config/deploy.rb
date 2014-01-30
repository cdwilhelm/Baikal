#require 'bundler/capistrano'

before "deploy:setup", "configure:php"
before "deploy:restart","deploy:extra_symlink", "deploy:migrate"
after "deploy:restart","deploy:cleanup"
before "deploy:finalize_update","configure:vhost","configure:composer_install","configure:db"


set :application, "baikal"

set :user, 'coachcrm'
set :user_group, 'apache:apache'
set :use_sudo, true
set :repository, "git@github.com:cdwilhelm/Baikal.git" 
set :scm, :git
set :deploy_via, 'remote_cache'
set :branch, 'master'
set :keep_releases, 5
#set :app_path,"#{application}"


ssh_options[:forward_agent] = true
ssh_options[:port] = 4222
default_run_options[:pty] = true  # Must be set for the password prompt
# from git to work


set :stages, %w(staging local production)
set :default_stage, "staging"
require 'capistrano/ext/multistage'


namespace :deploy do
 task :finalize_update, :except => { :no_release => true } do
    transaction do
     # run "chmod -R ug+w #{latest_release}/Specifics"
      run "sudo chown -R #{user_group} #{latest_release}"
    end
  end

  task :migrate do
    # do nothing
  end
  task :extra_symlink do
    #do nothing
  end
  
  task :restart, :except => { :no_release => true } do
    run "sudo service httpd restart"
  end
end
namespace :configure do
  task :db do
    run %{sudo sed -ier "/DBNAME/s/'[^']*'/'#{db_name}'/2" #{latest_release}/Specific/config.system.php}
  end
  
  task :vhost do
    #run "sudo cp #{latest_release}/Specific/virtualhosts/baikal.conf /etc/httpd/conf.d"
    #run %{sudo sed -ier "s/ServerName .*/ServerName #{pub_server_name}/" /etc/httpd/conf.d/baikal.conf}
  end
  task :php do
    run "sudo yum -y install php-xml php-mbstring php-pdo"
  end
  task :composer_install do
    run "cd #{latest_release};curl -sS https://getcomposer.org/installer | php"
    run "php #{latest_release}/composer.phar install --working-dir #{latest_release}"
end
  
end


