{"changed":true,"filter":false,"title":"application.js","tooltip":"/your_site/app/assets/javascripts/application.js","value":"// This is a manifest file that'll be compiled into application.js, which will include all the files\n// listed below.\n//\n// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,\n// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.\n//\n// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the\n// compiled file.\n//\n// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details\n// about supported directives.\n//\n//= require jquery\n//= require jquery_ujs\n//= require turbolinks\n//= require_tree .\n\n\nfiles = Dir[\"/home/ubuntu/workspace/bootstrap/css/*.css\"]\n\nfiles.each do |file_name|\n  if !File.directory? file_name\n    puts file_name\n    end\n  end","undoManager":{"mark":-2,"position":2,"stack":[[{"start":{"row":16,"column":0},"end":{"row":17,"column":0},"action":"insert","lines":["",""],"id":2}],[{"start":{"row":17,"column":0},"end":{"row":18,"column":0},"action":"insert","lines":["",""],"id":3}],[{"start":{"row":18,"column":0},"end":{"row":24,"column":5},"action":"insert","lines":["files = Dir[\"/home/ubuntu/workspace/bootstrap/css/*.css\"]","","files.each do |file_name|","  if !File.directory? file_name","    puts file_name","    end","  end"],"id":4}],[{"start":{"row":18,"column":0},"end":{"row":24,"column":5},"action":"remove","lines":["files = Dir[\"/home/ubuntu/workspace/bootstrap/css/*.css\"]","","files.each do |file_name|","  if !File.directory? file_name","    puts file_name","    end","  end"],"id":5}]]},"ace":{"folds":[],"scrolltop":118,"scrollleft":0,"selection":{"start":{"row":24,"column":5},"end":{"row":24,"column":5},"isBackwards":false},"options":{"guessTabSize":true,"useWrapMode":false,"wrapToView":true},"firstLineState":0},"timestamp":1437800257000}