{"filter":false,"title":"mailltest1.rb","tooltip":"/mailltest1.rb","undoManager":{"mark":1,"position":1,"stack":[[{"start":{"row":0,"column":0},"end":{"row":30,"column":18},"action":"insert","lines":["#Turn on - https://www.google.com/settings/security/lesssecureapps","","require 'mail'","","options = { :address              => \"smtp.gmail.com\",","            :port                 => 587,","            :domain               => 'localhost',","            :user_name            => 'selvasehea@gmail.com',","            :password             => '51007205094',","            :authentication       => 'plain',","            :enable_starttls_auto => true,","              }","","","","Mail.defaults do","  delivery_method :smtp, options","end","","","Mail.deliver do","       to 'selvasehea@gmail.com'","     from 'selvasehea@gmail.com'","  subject 'testing sendmail'","     body 'testing sendmail'","end","puts Mail::TestMailer.deliveries.length","puts Mail::TestMailer.deliveries.first","puts Mail::TestMailer.deliveries.clear","emails = Mail.all","puts emails.length"],"id":1}],[{"start":{"row":27,"column":0},"end":{"row":30,"column":18},"action":"remove","lines":["puts Mail::TestMailer.deliveries.first","puts Mail::TestMailer.deliveries.clear","emails = Mail.all","puts emails.length"],"id":2}]]},"ace":{"folds":[],"scrolltop":80,"scrollleft":0,"selection":{"start":{"row":27,"column":0},"end":{"row":27,"column":0},"isBackwards":false},"options":{"guessTabSize":true,"useWrapMode":false,"wrapToView":true},"firstLineState":{"row":4,"state":"start","mode":"ace/mode/ruby"}},"timestamp":1470208993829,"hash":"fee27e880f167bee933cdf422212f8e37e66c2ae"}