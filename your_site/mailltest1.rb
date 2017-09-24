#Turn on - https://www.google.com/settings/security/lesssecureapps

require 'mail'

options = { :address              => "smtp.gmail.com",
            :port                 => 587,
            :domain               => 'localhost',
            :user_name            => 'selvasehea@gmail.com',
            :password             => '51007205094',
            :authentication       => 'plain',
            :enable_starttls_auto => true,
              }



Mail.defaults do
  delivery_method :smtp, options
end


Mail.deliver do
       to 'selvasehea@gmail.com'
     from 'selvasehea@gmail.com'
  subject 'testing sendmail'
     body 'testing sendmail'
end
puts Mail::TestMailer.deliveries.length
puts Mail::TestMailer.deliveries.first
puts Mail::TestMailer.deliveries.clear
emails = Mail.all
puts emails.length