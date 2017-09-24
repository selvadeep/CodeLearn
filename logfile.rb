cmptxt="TotalCopiedSkippedMismatchFAILEDExtras"
cmptxt=cmptxt.delete(' ')
files = Dir["/home/ubuntu/workspace/Logdetails/*.txt"]
files.each do |file_name|
if !File.directory? file_name
   #puts file_name
f = File.open(file_name)
i=0
j=1

chk="false"
line_num=0
f.each do |line|
line_num=line_num += 1
org_line=line 
dup_line=line 
line=dup_line.delete(' ')

#puts "L=>"+line
#puts "C=>"+cmptxt
#a=cmptxt.length
#b=line.length
#line=line.to_s
#cmptxt=cmptxt.to_s
line=line.chomp!
cmptxt=cmptxt
puts " ERROR====>"+line_num.to_s+file_name if org_line.upcase.include? "ERROR"
if line == cmptxt or chk=="true"
    #puts "L=>"+"#{a}"+line
    #puts "C=>"+"#{b}"+cmptxt
    #puts a+b
    #puts chk
    #puts line
chk="true"
rb=org_line.split(' ') 
rbb=org_line.split(' ') 
    if i  >  0
        #puts org_line
        if j > 0 and j < 4
            if j==3

            kk=1
             rbb.each do |f|                                                                                                                                
                 if kk == 10                                                                                                                                     
                    #puts 1  
                    if f== "0"
                       # puts f
                    else
                        puts "Failed====>"+line_num.to_s+file_name
                        #break
                    end                                                                                                                                      
                else                                                                                                                                          
                    #puts f                                                                                                                                        
                end 
                    kk=kk+1 
              
            end 
else
            k=1
             rb.each do |f|                                                                                                                                
                 if k == 7                                                                                                                                     
                    #puts 1  
                    if f== "0"
                        #puts f
                    else
                        puts "Failed====>"+line_num.to_s+file_name   
                        #break
                    end                                                                                                                                      
                else                                                                                                                                          
                    #puts f                                                                                                                                        
                end 
                    k=k+1 
              
            end 


            end            
                j=j+1                                                                                                                                       
 
        else
        chk="false"                                                                                                                                       
        end 
    else    
      i=i+1
    end
else
    #puts 'ppppppppppppppppppppppppppppppppppppppppppp'
end
end
end
end