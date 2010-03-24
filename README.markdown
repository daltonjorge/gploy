## Introduction

This is a sample RubyGems to configure your Rails Project for deployment using git push, this gem only make a series of configurations in your local project and to in your web server. This gem consider what you are using locaweb to host your project and using git obviously.

## What directory structure is used
This gem use a structure in webserver like this:

	1. ~/repos  -> For host a git repository
	2. ~/rails_app -> For host your production project
	3. ~/public_html -> For create a  syslink to the project in rails_app directory 

## Files generated
This gem generate only two simple file into the config directory in your rails project, one file is called config.yaml and other is post-receive.

### The config.yaml file:

This content file should be like this:
	
	config:
	      url: host
	      user: username
	      password: password
	      app_name: project_name
	      origin: git origin
	
If your git is already configured as origin use another, for example: production

### The post-receive file:

This file shoudl be like this:
	
	      #!/bin/sh
          cd ~/rails_app/project_name
          env -i git reset --hard 
          env -i git pull project_name master
          env -i rake db:migrate RAILS_ENV=production
          env -i touch ~/rails_app/project_name/tmp/restart.txt

The post-receive file is a git hook, read more about hooks at: 


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
