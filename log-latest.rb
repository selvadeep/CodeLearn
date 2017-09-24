files = Dir["/home/ubuntu/workspace/Logdetails/*.txt"]
files.each do |file_name|
    puts file_name
if !File.directory? file_name
data = []
count=0   
$val=0
File.foreach(file_name) do |line|
    
#####################
if line.upcase.include? "ERROR"
    $val=10 
    puts "Passed"
    puts $val
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
else
puts "Do Nothing"
puts $val
end
end
end