namespace :db do
  namespace :data do
    desc "Dump current environments database to db/data_dump"
    task :dump => :environment do
      cmd = "mongodump #{session_opts} -o db/data_dump"
      puts "Running '#{cmd}'"
      `#{cmd}`
    end
    
    desc "Load db/data_dump into current environments database"
    task :load => :environment do
      db_name = Mongoid.sessions[:default][:database]
      cmd = "mongorestore #{session_opts} db/data_dump/#{db_name}/"
      puts "Running '#{cmd}'"
      `#{cmd}`
    end
    
    def session_opts
      host =  Mongoid.sessions[:default][:hosts].join(",")
      db_name = Mongoid.sessions[:default][:database]
      username = Mongoid.sessions[:default][:username]
      password = Mongoid.sessions[:default][:password]
      auth_string = ""
      auth_string += "--username #{username}" if username
      auth_string += "--password #{password}" if password
      "#{auth_string} --host #{host} -d #{db_name}"
    end
  end
end