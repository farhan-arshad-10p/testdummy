namespace :ci do
  def write_config(file, content)
    File.open(Rails.root.join('config', file), 'w') { |f| f.puts content }
  end

  task :database do
    write_config 'database.yml', <<EOS
development:
  adapter: mysql2
  encoding: utf8
  reconnect: false
  database: workr_development
  pool: 5
  username: root
  password:
test:
  adapter: mysql2
  encoding: utf8
  reconnect: false
  database: workr_test
  pool: 5
  username: root
  password:
EOS
  end

  task prepare: [ :database ]
end

# running the db:migrate dependences places the rails environment in development
# if we chain the spec tasks after the db tasks, the rails env is still development
# and the spec tasks dont work
#
# so, we use exec to clear out the rails env and run the spec tasks in a new
# version of this process.
#
# this is what it takes to get a single CI command that blends database migration
# and tests.

desc 'Continuous integration task'
task ci: %w[ ci:prepare db:drop db:create db:migrate ] do
  exec({ 'RAILS_ENV' => nil }, 'rake')
end
