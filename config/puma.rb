# threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }.to_i
# threads threads_count, threads_count
# #port        ENV.fetch("PORT") { 3000 }
# environment ENV.fetch("RAILS_ENV") { "development" }
# plugin :tmp_restart

# app_root = File.expand_path("../..", __FILE__)
# bind "unix://#{app_root}/tmp/sockets/puma.sock"

# stdout_redirect "#{app_root}/log/puma.stdout.log", "#{app_root}/log/puma.stderr.log", true
environment ENV.fetch("RAILS_ENV") { "development" }

max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }

plugin :tmp_restart
threads min_threads_count, max_threads_count
if ENV['RAILS_ENV'] == 'production'
  app_root = File.expand_path("../..", __FILE__)
  bind "unix://#{app_root}/tmp/sockets/puma.sock"
  stdout_redirect "#{app_root}/log/puma.stdout.log", "#{app_root}/log/puma.stderr.log", true
else
  port        ENV.fetch("PORT") { 3000 }
  pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }
end
