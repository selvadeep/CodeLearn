fstip = "10.112.0.0"
lstip = "10.112.63.255"
n=3
lstip=lstip.to_s
n1=lstip.split(/\./, n+1)[0...n].join('.')
n=2
lstip=lstip.to_s
n2=lstip.split(/\./, n+1)[0...n].join('.')
count=n1.length-n2.length-1
puts n1.length
puts count
n=n1.length-count
ending=n1[n..-1] 


n=3
fstip=fstip.to_s
n1=fstip.split(/\./, n+1)[0...n].join('.')
puts n1
n=2
fstip=fstip.to_s
n2=fstip.split(/\./, n+1)[0...n].join('.')
puts n2
count=n1.length-n2.length-1
puts n1.length
puts count
n=n1.length-count
starting=n1[n..-1] 

starting=starting.to_i
ending=ending.to_i
a=[]
for i in starting..ending
val="#{n2}.#{i}"
puts val
a<<val
end
puts a.inspect

match="10.112.14"
a.each do |i|
if i==match
puts "Matched"
end
end