module Gploy
  module Helpers  
    LOG_PATH = './log/gploylog.log'
    
    def check_if_dir_log_exists
      unless dirExists?("log")
        Dir.mkdir("log") 
        false
      else
        true
      end
    end
    
    def logger(msg, type)
      puts "--> #{msg}"
      File.open(LOG_PATH, 'a+') do |f|
        f.puts "#{Time.now} => |#{type}| #{msg}"
      end
    end
    
    def run_remote(command)
      logger(command, "remote")
      @shell.exec!(command)
    end

    def dirExists?(dir)
      File.directory? dir
    end

    def run_local(command)
      logger(command, "local")
      Kernel.system command
    end

    def sys_link(name)
      run_remote "ln -s ~/rails_app/#{name}/public ~/public_html/#{name}"
    end
    
    def update_hook_into_server(username, url, name)
      run_local "chmod +x config/post-receive && scp config/post-receive #{username}@#{url}:repos/#{name}.git/hooks/"
    end

    def update_hook(username, url, name)
      run_local "scp config/post-receive #{username}@#{url}:repos/#{name}.git/hooks/"
    end
    
    def useMigrations?
      if File.exists?("db/schema.rb")
        true
      else
        false
      end
    end

    def migrate(name)
      if useMigrations?
        logger("Run db:migrate", "remote")
        run_remote "cd rails_app/#{name}/ && rake db:migrate RAILS_ENV=production"
      end
      logger("rake db:migrae => FALSE", nil)
    end

    def restart_server(name)
      logger("restart server", "remote")
      run_remote "cd rails_app/#{name}/tmp && touch restart.txt"
    end

    def post_commands
      commands = <<CMD
        #!/bin/sh
        cd ~/rails_app/#{@app_name}
        env -i git reset --hard 
        env -i git pull #{@origin} master
        env -i rake db:migrate RAILS_ENV=production
        env -i touch ~/rails_app/#{@app_name}/tmp/restart.txt 
CMD
         puts commands
    end

    def post_commands_server
      commands = <<CMD
        config:
        url: <user_server>
        user: <userbae>
        password: <password>
        app_name: <app_name>
        origin: <git origin>
CMD
        puts commands
    end
  end
end
