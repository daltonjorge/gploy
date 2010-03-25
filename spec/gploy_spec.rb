require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

include FakeFS

describe Gploy::Configure do 
  
  before(:each) do
    @ssh = mock(Net::SSH)
    @response = mock(Net::SSH)
    @connection = Gploy::Configure.new
    @connection.should_receive(:start).and_return(@ssh)
    @c = @connection.remote
    
    @url = "server_name"
    @user = "user_name"
    @password = "user_senha"
    @app_name = "fake_project"
    @origin = "production"
  end
  
  it "should have a gem version" do
    Gploy::Configure::VERSION.should_not be_nil
  end
  
  it "should return a gem version" do
   Gploy::Configure::VERSION.should == "0.1.2"
  end
  
  it "should return correct command to upload file" do
   expect_command_local "chmod +x config/post-receive && scp config/post-receive #{@user}@#{@url}:repos/#{@app_name}.git/hooks/"
   @connection.update_hook_into_server(@user, @url, @app_name)
  end
  
  it "should upload post-receive file" do
    expect_command_local "scp config/post-receive #{@user}@#{@url}:repos/#{@app_name}.git/hooks/"
    @connection.update_hook(@user, @url, @app_name)
  end
    
  it "should ensure that have a config.yaml into the config directory" do
    @connection.create_file_and_direcotry_unless_exists("config", "config.yaml")
    File.should exist("config/config.yaml")
  end
 
  it "should return a path for hook post-receive file into server" do
    @connection.path_hook(@name).should  == "~/repos/#{@name}.git/hooks/post-receive"
  end

  it "should create a repository and initialize git in server" do
    expect_command_remote "cd repos/ && mkdir nome.git && cd nome.git && git init --bare"
    @connection.create_repo("nome")
  end
 
  it "should add git remote origin in local project" do
   expect_command_local "git remote add #{@origin} #{@user}@#{@url}:~/repos/#{@app_name}.git"
   @connection.add_remote(@url, @user, @app_name, @origin)
  end
 
  it "should run clone into server" do
   expect_command_remote "git clone ~/repos/#{@app_name}.git ~/rails_app/#{@app_name}"
   @connection.clone(@app_name)
  end
    
  it "should have a file post-receive into the config folder" do
   @connection.create_hook_file
   File.should exist("config/post-receive")
  end
 
 it "should have hook file" do
   File.should exist("config/post-receive")
 end
  
 it "should have return a path to post-receive" do
   @connection.path.should == "config/post-receive"
 end
  
 it "should clone project into the server" do
   expect_command_remote "git clone repos/#{@app_name}.git ~/rails_app/#{@app_name}"
   @connection.clone_into_server(@app_name)
 end
 
 it "should create a symbolic link into the server" do
   expect_command_remote "ln -s ~/rails_app/#{@app_name}/public ~/public_html/#{@app_name}"
   @connection.sys_link(@app_name)
 end

 it "should run push origin master" do
  expect_command_local "git push #{@origin} master"
  @connection.push_local(@origin)
 end
 
 it "should create a tmp directory into the project folder in server" do
  expect_command_remote "cd rails_app/#{@app_name}/ && mkdir tmp"
  @connection.tmp_create(@app_name)
 end
 
end