require 'net/smtp'
files = Dir["C:/Sites/clearcaselog/Logs/*.txt"]
files.each do |file_name|
    puts file_name
if !File.directory? file_name
data = []
count=0   
$val=0
$name=file_name
File.foreach(file_name) do |line|
    
#####################
if line.upcase.include? "ERROR"
    $val=10 
    #puts "Passed"
    #puts $val
end
#####################
    
    
line.chomp!
temp_line = line.delete(' ')
if temp_line =~ /TotalCopiedSkippedMismatchFAILEDExtras/
count=count+1
else
if ((count > 0) & (count <= 3))
count+=1
line = line.split('  ')
line.delete("")
data.push [line[5].strip.to_i]
end
end
end
data = data.flatten
#puts data
if data.max > 0 ||  $val > 0
    $val=0
puts "Send Alert!!"

######################################

message = <<MESSAGE_END
From: <selvaganapathi.m@hcl.com>
To: <HCL_AGILENT_SETOOLS_CLSLLS_SUPPORT@hcl.com>
MIME-Version: 1.0
Content-type: text/html
Subject: Attention

<p>Hi Team,</p>
<p>The VOB backup from localdisk to LUN got failed. Please check the below log files and take the action.
</p> 
 <p><b>Regards,</b></p>
  CC Admin

MESSAGE_END

Net::SMTP.start('germany.smtp.agilent.com') do |smtp|
  smtp.send_message message,'selvaganapathi.m@hcl.com','thiyagu.p@hcl.com'                        #'selvaganapathi.m@hcl.com','HCL_AGILENT_SETOOLS_CLSLLS_SUPPORT@h#cl.com'                       
end

##########################################

else
puts "Do Nothing"
puts $val
end
end
end