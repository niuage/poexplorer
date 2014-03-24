require "bundler/capistrano"

load "config/recipes/base"
load "config/recipes/nginx"
load "config/recipes/unicorn"
# load "config/recipes/postgresql"
load "config/recipes/nodejs"
# load "config/recipes/rbenv"
load "config/recipes/rvm"
load "config/recipes/check"
load "config/recipes/elasticsearch"
load "config/recipes/seed"

set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

require "bugsnag/capistrano"


# server "192.155.89.175", :web, :app, :db, primary: true
server "198.211.107.93", :web, :app, :db, primary: true

set :user, "deploy"
set :application, "poesearch"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "git@github.com:niuage/#{application}.git"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases

desc "Make sure local git is in sync with remote."
task :check_revision, roles: :web do
  unless `git rev-parse HEAD` == `git rev-parse origin/master`
    puts "WARNING: HEAD is not the same as origin/master"
    puts "Run `git push` to sync changes."
    exit
  end
end
before "deploy", "check_revision"
