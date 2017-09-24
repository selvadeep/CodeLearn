#http://stuff-things.net/2016/03/02/advanced-ruby-imap/
#http://stackoverflow.com/questions/10320596/need-help-on-reading-emails-with-mail-gem-in-ruby
#http://stackoverflow.com/questions/2666798/fetching-email-using-ruby-on-rails
#!/usr/bin/env ruby

require 'net/pop'
Net::POP3.enable_ssl(OpenSSL::SSL::VERIFY_NONE)  
Net::POP3.start('pop.gmail.com', 995, username, password) do |pop|  
  if pop.mails.empty?  
    puts 'No mails.'  
  else  
    pop.each_mail do |mail|  
      p mail.header  
      p mail.pop  
    end  
  end  
end  