set :application, "amalgama"
set :scm, "git" 
set :user, "hustlr" 
set :repo_url, "git@github.com:Canfly/#{fetch(:application)}.git"

set :deploy_to, "/home/#{fetch(:user)}/#{fetch(:application)}"

set :linked_files, %w{config/database.yml config/diaspora.yml}
#set :linked_files, %w{config/nginx.conf config/diaspora.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/uploads}

set :config_files, %w(nginx.conf)

set :symlinks, [
	{
		source: 'nginx.conf', link: '/etc/nginx/nginx.conf'
	}
	# => ,
	# => {
	# => source: "unicorn_init.sh",
	# => link: "/etc/init.d/unicorn_{{full_app_name}}"
	# => },
]

namespace :deploy do 

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

#   after :publishing, :restart

# end
#  task :setup_config do
#  	on roles(:app), in: :sequence, wait: 5  do
#  		#sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/conf.d/#{application}"
#    	#sudo "ln -nfs #{current_path}/config/unicorn_ini.sh /etc/init.d/unicorn_#{application}"
#    	run "mkdir -p #{shared_path}/config"
#    	put File.read("config/database.yml"), "#{shared_path}/config/database.yml"
#    	puts "Now edit the config files in #{shared_path}."
#  	end
#  end
  
  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
end

#remote_file 'config/nginx.conf' => '/tmp/nginx.conf', roles: :app

#  file '/tmp/nginx.conf' do |t|
 #   sh "curl -o #{t.name} https://rpm.newrelic.com/accounts/xx/nginx.conf"
  #end

########## deploy-2

#require "bundler/capistrano" 
#
## Define your server here
#server "95.85.4.75", :web, :app, :db, primary: true
#
## Set application settings
#set :application, "amalgama"
#set :user, "hustlr" # As defined on your server
#set :deploy_to, "/home/#{user}/#{application}" # Directory in which the deployment will take place
#set :deploy_via, :remote_cache
#set :use_sudo, false
#
#set :scm, "git" 
#set :repository, "git@github.com:Canfly/#{application}.git"
#set :branch, "master"
#
#default_run_options[:pty] = true
#ssh_options[:forward_agent] = true
#
#after "deploy", "deploy:cleanup" # keep only the last 5 releases
#
#namespace :deploy do
#  %w[start stop restart].each do |command|
#    desc "#{command} unicorn server"
#    task command, roles: :app, except: {no_release: true} do
#      run "/etc/init.d/unicorn_#{application} #{command}" # Using unicorn as the app server
#    end
#  end
#
#  task :setup_config, roles: :app do
#    sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/conf.d/#{application}"
#    sudo "ln -nfs #{current_path}/config/unicorn_ini.sh /etc/init.d/unicorn_#{application}"
#    run "mkdir -p #{shared_path}/config"
#    put File.read("config/database.yml"), "#{shared_path}/config/database.yml"
#    puts "Now edit the config files in #{shared_path}."
#  end
#  after "deploy:setup", "deploy:setup_config"
#
#  task :symlink_config, roles: :app do
#    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
#  end
#  after "deploy:finalize_update", "deploy:symlink_config"
#
#  desc "Make sure local git is in sync with remote."
#  task :check_revision, roles: :web do
#    unless `git rev-parse HEAD` == `git rev-parse origin/master`
#      puts "WARNING: HEAD is not the same as origin/master"
#      puts "Run `git push` to sync changes."
#      exit
#    end
#  end
#  before "deploy", "deploy:check_revision"
#end