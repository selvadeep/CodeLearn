require 'mail'
options = { :address              => "smtp.gmail.com",
            :port                 => 587,
            :domain               => 'gmail.com',
            :user_name            => 'selvasehea@gmail.com',
            :password             => '51007205094',
            :authentication       => 'plain',
            :enable_starttls_auto => true  }
            
Mail.defaults do
  delivery_method :smtp, options
end


mail = Mail.new do
  from    "selvasehea@gmail.com"
  to      "vairamuthu-sh@hcl.com"
  subject "This is a test email"
  body    "Hello"
end


mail = Mail.new do
  from    "selvasehea@gmail.com"
  to      "vairamuthu-sh@hcl.com"
  subject 'testing sendmail'
     body 'testing sendmail'
end

mail.deliver
