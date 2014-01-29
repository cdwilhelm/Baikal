require 'bundler/capistrano'

before "deploy:setup", "configure:php"
before "deploy:restart","deploy:extra_symlink", "deploy:migrate"
after "deploy:restart","deploy:cleanup"
after "deploy:update","configure:vhost","configure:composer_install"


set :application, "baikal"

set :user, 'root'
set :use_sudo, true
set :repository, "git@github.com:cdwilhelm/Baikal.git" 
set :scm, :git
set :deploy_via, 'remote_cache'
set :branch, 'master'
set :keep_releases, 5
set :app_path,"#{application}"
set :deploy_to, "/var/www/#{app_path}"

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
      run "chmod -R g+w #{releases_path}/#{release_name}"
    end
  end

  task :migrate do
    # do nothing
  end

  task :restart, :except => { :no_release => true } do
    run "sudo service httpd restart"
  end
end
namespace :configure do
  task :vhost do
    run "sudo cp #{deploy_to}/Specific/baikal.conf /etc/httpd/conf.d | sed -ier \"|/var/www/baikal/html|#{deploy_to}/html| /etc/httpd/conf.d/baikal.conf\""
    run "sudo service httpd restart"
  end
  task :php do
    run "sudo yum -y install php-xml php-mbstring php-pdo"
  end
  task :composer_install do
    run "cd #{latest_release};curl -sS https://getcomposer.org/installer | php"
    run "php /var/www/#{app_path}/composer.phar install --working-dir #{latest_release}"
end
  
end


