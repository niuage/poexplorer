RAILS_ROOT = "/Users/robinboutros/localhost/poexplorer"
RAILS_ENV = "development"

def base(w)
  w.dir = "#{RAILS_ROOT}"

  w.pid_file = File.join(RAILS_ROOT, "log/#{w.name}.pid")

  w.interval = 30.seconds
  w.pid_file = "#{RAILS_ROOT}/tmp/pids/#{w.name}.pid"
  w.env = {
    'RAILS_ENV' => RAILS_ENV,
    'PIDFILE' => w.pid_file
  }

  w.keepalive
end

God.watch do |w|
  w.name = "permanent_leagues"
  base(w)

  w.start = "bundle exec rake crawler:permanent &"
end

God.watch do |w|
  w.name = "seasonal_leagues"
  base(w)

  w.start = "bundle exec rake crawler:seasonal &"
end

God.watch do |w|
  w.name = "player_import"
  base(w)

  w.start = "bundle exec rake players:import &"
end
