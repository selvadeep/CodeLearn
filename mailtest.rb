#https://github.com/mikel/mail
#http://codebeerstartups.com/2013/01/how-to-fetch-and-parse-emails-in-ruby-on-rails/


imap=Net::IMAP.new('mail.hcl.com') #of course these are not real
imap.login('selvaganapathi.m','password2!')
imap.select('INBOX')
imap.search(["Got it now",(Time.now-1.day).strftime("%d-%b-%Y")]).each do |msgid|
     body = imap.fetch(msgid,"BODY")[0].attr["BODY"]
     puts body
     ##insert code for getting the text from the body here
     ##body.class is BodyTypeText 
end