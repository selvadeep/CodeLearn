{"filter":false,"title":"mailltest1.rb","tooltip":"/your_site/mailltest1.rb","undoManager":{"mark":0,"position":0,"stack":[[{"start":{"row":0,"column":0},"end":{"row":30,"column":18},"action":"insert","lines":["#Turn on - https://www.google.com/settings/security/lesssecureapps","","require 'mail'","","options = { :address              => \"smtp.gmail.com\",","            :port                 => 587,","            :domain               => 'localhost',","            :user_name            => 'selvasehea@gmail.com',","            :password             => '51007205094',","            :authentication       => 'plain',","            :enable_starttls_auto => true,","              }","","","","Mail.defaults do","  delivery_method :smtp, options","end","","","Mail.deliver do","       to 'selvasehea@gmail.com'","     from 'selvasehea@gmail.com'","  subject 'testing sendmail'","     body 'testing sendmail'","end","puts Mail::TestMailer.deliveries.length","puts Mail::TestMailer.deliveries.first","puts Mail::TestMailer.deliveries.clear","emails = Mail.all","puts emails.length"],"id":1}],[{"start":{"row":27,"column":0},"end":{"row":30,"column":18},"action":"remove","lines":["puts Mail::TestMailer.deliveries.first","puts Mail::TestMailer.deliveries.clear","emails = Mail.all","puts emails.length"],"id":2}]]},"ace":{"folds":[],"scrolltop":0,"scrollleft":0,"selection":{"start":{"row":0,"column":0},"end":{"row":25,"column":3},"isBackwards":true},"options":{"guessTabSize":true,"useWrapMode":false,"wrapToView":true},"firstLineState":0},"timestamp":1470209227000,"hash":"4ea429e1ab251fb45b88f30b291971477431a671"}