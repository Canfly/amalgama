set :application, 'amalgama'
set :repo_url, 'git@github.com:Canfly/amalgama.git'

set :deploy_to, '/home/hustlr/amalgama'

set :linked_files, %w{config/database.yml config/diaspora.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/uploads}

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