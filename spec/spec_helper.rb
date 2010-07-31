$LOAD_PATH.unshift(File.join(File.dirname(__FILE__)))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
 
require 'rubygems'
require 'gploy'
require 'spec'




def expect_command_local(command)
  Kernel.should_receive(:system).with(command)
end

def expect_command_remote(command)
  @c.should_receive(:exec!).with(command)
end

def dirExists?(dir)
 File.directory? dir
end