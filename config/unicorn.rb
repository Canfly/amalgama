require File.expand_path('../load_config', __FILE__)

# Enable and set these to run the worker as a different user/group
#user  = 'diaspora'
#group = 'diaspora'

worker_processes AppConfig.server.unicorn_worker.to_i

## Load the app before spawning workers
preload_app true

# How long to wait before killing an unresponsive worker
timeout AppConfig.server.unicorn_timeout.to_i

@sidekiq_pid = nil

#pid '/var/run/diaspora/diaspora.pid'
#listen '/var/run/diaspora/diaspora.sock', :backlog => 2048


stderr_path AppConfig.server.stderr_log.get if AppConfig.server.stderr_log.present?
stdout_path AppConfig.server.stdout_log.get if AppConfig.server.stdout_log.present?

before_fork do |server, worker|
 # If using preload_app, enable this line
 ActiveRecord::Base.connection.disconnect!

 # disconnect redis if in use
 unless AppConfig.single_process_mode?
   Sidekiq.redis {|redis| redis.client.disconnect }
 end

 if AppConfig.server.embed_sidekiq_worker?
   @sidekiq_pid ||= spawn('bundle exec sidekiq')
 end

 old_pid = '/var/run/diaspora/diaspora.pid.oldbin'
 if File.exists?(old_pid) && server.pid != old_pid
   begin
     Process.kill("QUIT", File.read(old_pid).to_i)
   rescue Errno::ENOENT, Errno::ESRCH
     # someone else did our job for us
   end
 end
end


after_fork do |server, worker|
 # If using preload_app, enable this line
 ActiveRecord::Base.establish_connection

 # We don't generate uuids in the frontend, but let's be on the safe side
 UUID.generator.next_sequence
end

##########

#root = "/home/deployer/apps/projectname/current"
#working_directory root
#pid "#{root}/tmp/pids/unicorn.pid"
#stderr_path "#{root}/log/unicorn.log"
#stdout_path "#{root}/log/unicorn.log"

#listen "/tmp/unicorn.projectname.sock"
#worker_processes 2
#timeout 30

# Force the bundler gemfile environment variable to
# reference the capistrano "current" symlink
#before_exec do |_|
#  ENV["BUNDLE_GEMFILE"] = File.join(root, 'Gemfile')
#end

