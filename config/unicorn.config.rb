# This is the configuration for running apps with unicorn.
# See original here: http://projects.puppetlabs.com/projects/1/wiki/Using_Unicorn

worker_processes 2
working_directory '/home/deploy/poexplorer/'
listen '/var/lib/poexplorer/unicorn.sock', :backlog => 2048
timeout 300
pid "/var/run/unicorn/poexplorer.pid"
client_body_buffer_size 524288

stderr_path '/home/deploy/poexplorer//log/stderr.log'
stdout_path '/home/deploy/poexplorer//log/stdout.log'

preload_app true

# See http://unicorn.bogomips.org/SIGNALS.html for what this does.
before_fork do |server, worker|
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end


# Stolen from https://github.com/blog/517-unicorn
after_fork do |server, worker|

  begin
    uid, gid = Process.euid, Process.egid
    user  = 'deploy'
    group = 'deploy'
    target_uid = Etc.getpwnam(user).uid
    target_gid = Etc.getgrnam(group).gid
    worker.tmp.chown(target_uid, target_gid)
    if uid != target_uid || gid != target_gid
      Process.initgroups(user, target_gid)
      Process::GID.change_privilege(target_gid)
      Process::UID.change_privilege(target_uid)
    end
  rescue => e
    if RAILS_ENV == 'development'
      STDERR.puts "couldn't change user, oh well"
    else
      raise e
    end
  end
end
