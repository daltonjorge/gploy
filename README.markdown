Version 0.1.5 brings some improvements in the way it will deploy.

Notes Version 0.1.5

Now the file confi.yml won a new line, this line indicates which branch of git you want to deploy, in the version 0.1.4 gploy performed the deploy the current branch, since you now want to deploy can make using a new command called gploy -d or gploy --deploy  to change the branch and run deploy(git push) from the branch specified in config.yml

The log file was also changed to indicate that the command was run locally or remotely.

## Introduction

This is a simple RubyGems to configure your Rails Project for deployment using git push, this gem only make a series of configurations in your local project and to in your web server. This gem consider what you are using locaweb to host your project and using git obviously.

## What directory structure is used
This gem use a structure in webserver like this:

	1. ~/repos       -> For host a git repository
	2. ~/rails_app   -> For host your production project
	3. ~/public_html -> For create a  symlink to the project in rails_app directory 

## Files generated
This gem generate only two simple file into the config directory, one file is called config.yaml and other is post-receive.

### The config.yaml file:

The contents of this file must be like this:
	
	config:
	      url: host
	      user: username
	      password: password
	      app_name: project_name
	      origin: git origin
		  branch: git branch
		
If your git is already configured for origin use another, for example: production

### The post-receive file:

The contents of this file must be like this:
	
	      #!/bin/sh
          cd ~/rails_app/project_name
          env -i git reset --hard 
          env -i git pull project_name master
          env -i rake db:migrate RAILS_ENV=production
          env -i touch ~/rails_app/project_name/tmp/restart.txt

The post-receive file is a git hook, read more about hooks at: [www.ru.kernel.org](http://www.ru.kernel.org/pub/software/scm/git/docs/v1.5.2.5/hooks.html)

## Usage
First thing you must do is install the gploy gem in your computer:

	sudo gem install gploy

after it inside your rails project your must execute the following commands:

	> gploy -c // For generate config.yaml file

Now you can edit this file with your data, make sure you not have a origin set in git if you will use it. 

Now lets generate a post-receive file, this file is a git hook, and must have commands that you want that are executed when your run git push in your project, for this execute:
	
	> gploy -pr // For generate post-receive file
	
This command will generate a snippet like this:

		#!/bin/sh
		cd ~/rails_app/project_name
		env -i git reset --hard 
		env -i git pull project_name master
		env -i rake db:migrate RAILS_ENV=production
		env -i touch ~/rails_app/project_name/tmp/restart.txt

Put it inside the config/post-receive file. You can add more commands in the post-receive file if you want.

Finally now you can run the command that will upload your project to the server and do what needs to be done:

	> gploy -s

If no error occurs, your project must be available now.

From now when you want update your project simply do a commit of changes and run git push production master to update project in server or run:
   
	> gploy -d
#OBS: This is a initial version then careful when using it. If you find bugs please let me know, fell free for make a fork in project at [github](http://github.com/edipofederle/gploy) and fix the bugs :D.


## LICENSE:

(The MIT License)

Copyright (c) 2008 Edipo Luis Federle

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.