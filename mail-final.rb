require 'net/smtp'

message = <<MESSAGE_END
From: <selvaganapathi.m@hcl.com>
To: <HCL_AGILENT_SETOOLS_CLSLLS_SUPPORT@hcl.com>
Subject: SMTP e-mail test recently very  final

This is a test e-mail message.
MESSAGE_END

Net::SMTP.start('germany.smtp.agilent.com') do |smtp|
  smtp.send_message message, 'selvaganapathi.m@hcl.com','HCL_AGILENT_SETOOLS_CLSLLS_SUPPORT@hcl.com'
                         
end
