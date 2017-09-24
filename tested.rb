#http://www.samecs.com/how_do_i/ClearCase_VOBs/ClearCase%20VOBs%20how%20do%20I.htm
#http://www-01.ibm.com/support/docview.wss?uid=swg21134700 -remove vob|view
#http://onewebsql.com/blog/list-all-tables - Oracle db connection in unix terminal
require 'spreadsheet'
module Spreadsheet
class Workbook
attr_accessor :io
end
end
$book=Spreadsheet.open '/home/selva/Downloads/ipreg/ip.xls'
$book1=Spreadsheet.open '/home/selva/Downloads/ipreg/Agilent.xls'
$book2=Spreadsheet.open '/home/selva/Downloads/ipreg/Keysight.xls'
$sheet1 = $book.worksheet 'Sheet1'
$sheet2 = $book1.worksheet 'IPv4Network'
$sheet3 = $book2.worksheet 'IPv4Network'
$book4 = Spreadsheet::Workbook.new
$sheet4 = $book4.create_worksheet
notregip=0
for i in 0..240
 x=$sheet1[i,0]
 n=3
 x=x.to_s	
 kk=1
	for j in 0..1960
		y=$sheet2[j,2]
		n=3
		y=y.to_s
 		y=y.split(/\./, n+1)[0...n].join('.')
 			if x==y
 				puts "X: #{x}" 	
  		 		puts "Y: #{y}"
				puts 'hello'
				puts i
				puts j
				notregip=notregip+1
			 	$sheet4[notregip,1]=x
			else
				if kk==1
				for k in 0..1960
		 			#z=$sheet3[k,2]
                    fstip = $sheet3[k,2]
                    lstip = $sheet3[k,3]
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
                    #puts n1
                    n=2
                    fstip=fstip.to_s
                    n2=fstip.split(/\./, n+1)[0...n].join('.')
                    #puts n2
                    count=n1.length-n2.length-1
                    #puts n1.length
                    #puts count
                    n=n1.length-count
                    starting=n1[n..-1] 

                    starting=starting.to_i
                    ending=ending.to_i
                    a=[]
                    puts "#{starting}<=>#{ending}"
                    for i in starting..ending
                    val="#{n2}.#{i}"
                    puts val
                    a<<val
                    end
                    a.each do |i|
                    if x==i
                    notregip=notregip+1
                    $sheet4[notregip,2]=x
                    end
                    end
		 		
		 		
		 		
				end
			    end
 			end
 		kk=kk+1
	end
end
			 File.delete('/home/selva/Downloads/ipreg/out.xls')
			 $book4.write('/home/selva/Downloads/ipreg/out.xls')
 $book1.io.close


puts notregip




#sheet1[0,0] = Spreadsheet::Link.new 'www.google.com', 'link text'
#book.write 'spreadsheet_with_link.xls'
