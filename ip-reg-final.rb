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
for i in 0.. 240
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
				for k in 0..-1
		 			z=$sheet3[k,2]
		 			n=3
		  		 	z=z.to_s
 		 			z=z.split(/\./, n+1)[0...n].join('.')
 						if x==z
 							puts "X: #{x}" 	
  		 					puts "Z: #{z}"
							puts 'hello1'
							puts i
							puts k
							notregip=notregip+1
				 			$sheet4[notregip,2]=x	
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






