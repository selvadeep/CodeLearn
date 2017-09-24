require '/home/ubuntu/workspace/sample1.rb'
AGI_OVSD_FROM_ADDRESS="es-ops-elt.pdl-it@agilent.com"
email_sender = AGI_OVSD_FROM_ADDRESS
to_addr = "deepika_kg@hcl.com"
subj= "Testing mail"
body="Confirm test mail"
mailer=ELTmail::Mail.new({"from"=>email_sender, "to"=>to_addr, "subject"=>subj,"text"=>body, "html"=>true})
if mailer.send
    puts "success"
else
    puts "failure"
end
