require "rubygems"
require 'net/ssh'
require 'fileutils'
require 'yaml'
require 'net/sftp'

module Gploy
  class Configure
    
    include Helpers
    VERSION = '0.1.5'

    def configure_server
      create_file_and_direcotry_unless_exists("config", "config.yaml")
      puts "Files created into the config directory. Now need edit config.yaml"
      puts ""
      puts "---------------------------------------------------------"
      puts "You can put this content into your config.yaml file and edit it"
      post_commands_server
    end
    
    def configure_hook
      read_config_file
      create_file_and_direcotry_unless_exists("config", "post-receive")
      puts "Now you should edit config/post-receive file, like this:"
      puts ""
      post_commands
    end
  
    def setup
      check_if_dir_log_exists
      read_config_file
      remote
      initialize_local_repo
      create_repo(@app_name)
      add_remote(@url, @user, @app_name, @origin)
      push_local(@origin)
      clone_into_server(@app_name)
      add_remote_origin(@url, @user, @app_name, @origin)
      sys_link(@app_name)
      tmp_create(@app_name)
      update_hook_into_server(@user, @url, @app_name)
      run_tasks
      puts "OK. No error Found. You now can run <git push #{@origin} master> for update your project"
    end
    
    def upload_hook
      read_config_file
      remote
      update_hook(@user, @url, @app_name)
      puts "File successfully Updated"
    end
    
    def read_config_file
      config = YAML.load_file("config/config.yaml")
      config["config"].each { |key, value| instance_variable_set("@#{key}", value) }
    end
    
    def remote
      @shell = start(@url, @user, @password)
    end

    def path
      "config/post-receive"
    end
    
    def run_tasks
      migrate(@app_name)
      restart_server(@app_name)
    end
    
    def start(server, user, pass)
      Net::SSH.start(server, user, :password => pass)
    end
  
    def path_hook(name)
      "~/repos/#{name}.git/hooks/post-receive"
    end
  
    def create_repo(name)
      run_remote "cd repos/ && mkdir #{name}.git && cd #{name}.git && git init --bare"
    end

    def create_hook_file
      unless dirExists?("config")
        Dir.mkdir("config")
      end
      FileUtils.touch("config/post-receive")
    end
  
    def initialize_local_repo
      puts "Starting local git repository"
      unless dirExists?(".git/")
        run_local("git init && git add . && git commit -m 'Initial Commit' ")
      else
        puts "Git is already configured in this project"
      end
    end
  
    def create_file_and_direcotry_unless_exists(dir, file)  
      unless dirExists?("#{dir}")
        Dir.mkdir(dir)
      end
      unless File.exists?("config/#{file}")
        FileUtils.touch "#{dir}/#{file}"
      end
    end
  
    def add_remote(server, user, name, origin)
      run_local("git remote add #{origin} #{user}@#{server}:~/repos/#{name}.git")
    end
    
    def add_remote_origin(server, user, name, origin)
      run_remote("cd rails_app/#{name}/ && git remote add #{origin} ~/repos/#{name}.git/")
    end
    
    def new_deploy
      read_config_file
      run_local("git checkout #{@branch} - && git push #{@origin} master")
    end
  
    def clone(name)
      @shell.exec!("git clone ~/repos/#{name}.git ~/rails_app/#{name}")
    end
    
    def clone_into_server(name)
      run_remote "git clone repos/#{name}.git ~/rails_app/#{name}"
    end
    
    def push_local(origin)
      run_local "git checkout master && git push #{origin} master"
    end
    
    def tmp_create(name)
      run_remote "cd rails_app/#{name}/ && mkdir tmp"
    end
    
  end
end