How to install license to a specific application in server

Backup Server(cos-borg.cos.agilent.com):-
Here you have to take backup of two license files
A.	Current License file(this might expired or going to expire file) - old license file
B.	Will update license file(new license file) - new license file
Production Server:-
Here not going to maintain backup license file
To install application license file in a server, please follow the given steps
Generally in all applications files is located under 'license_files' folder in backup server
Same like all applications files is located under '/opt/flexlm/licensees/' folder in production server
1.	Go to Backup Server(cos-borg.cos.agilent.com):-
Before performing any action on a particular file, first of all checkout the file due to here server is using RCS version control system for that follow the below command
>> co -l license.dat 		// license.dat -> license file name
now we can do any operation(edit/update/delete) on that file.
2.	Go to cd license_files/ansys(Vndor Name)/sunny-server(Server Name)/current(license file is located in configuration foler)
Now take a backup of license.dat file for that follow the below command (First Backup)
>> cp -p license.dat license.dat_20160707		//license.dat_20160707 -> license.dat_YearMonthDate
// -p is optional -> this options not change any properties of original file like permission,ownership,created_at,updated_at and etc.
3.	Go to one step back cd .. // now your in 'license_files/ansys(Vndor Name)/sunny-server(Server Name)/'
Create a new folder to this format(YearMonthDate) for that follow the given command
>> mkdir 20160707				//Now new foler is created
Go to new folder, 
>> cd 20160707
Now copy the new license file from localhost to remote host using winscp or filezilla.
4.	 Go to one step forward currrent folder, 
>> cd current
Again taking second backup of license.dat file in date(20160707) folder location for that follow the given command, 			//Second Backup
>> cp -p license.dat  ../20160707/license.dat.old
5.	Go to one step back cd .. 	//Now your in date(20160707) folder
Next take a backup of license.dat.old file,
>> cp license.dat.old license.dat.new  	//Third Backup -> license.dat.new
6.	Open the license.dat.new file, follow the given command
>> vi license.dat.new	//vi - is a default editor in linux
Next find which application license file need to change in license.dat.new, go to that line and follw the given command to read(copy the from new license to license.dat.new file)
:r suuny-sever-license.dat 	// path(like license_files/ansys(Vndor Name)/sunny-server(Server Name/20160707/new-license-file.dat) of sunny server license file(which was copied from local to remote)
Now the new license file is copied in to license.dat.new and save the vi editor to do follow the given command
ESC+:+wq!
Finally new license file is ready...
Note:-
Few shortcuts in vi editor are,
SHIFT+G -> End fo file
G+G -> Begining of a document
:q! -> Force Quit without save
:wq! -> Force Quit with Save
:r - reading a another file
7.	Now copy the license.dat.new(edited license file) to current folder, please follow the given command
>> cp license.dat.new /current/license.dat.new
Next move to current folder,
>> cd current
8.	Go to production server
Now open new putty terminal or duplicate the same putty termial
Next go to scs-sunny login for that follow the given command  // Production Server
>> ssh scs-sunny 	//Now see in the terminal username will change to scs-sunny
Go to license.dat cofiguration file,
>> cd /opt/flexlm/licensees
>> cd ansymld (which application server folder)
Next copy the latest edit license file(license.dat.new which is located in backup server) to production server for that follow the given command,
>> scp cos-borg.cos.agilent.com:/path of license.dat.new file  /license.date.new
Now take a backup of a license.dat file
>> cp -p license.dat license.dat_20160707
Finally rename from license.dat.new to license.dat	// Only one license file inside the configuration folder
9.	To see the logs in production Server,
>> tail -f lmgrd.dl	//lmgrd.dl is a logfile
10.	Go to backup server(cos-borg.cos.agilent.com)
Now restart a particular application server(scs-sunny server),
>> restart_folder.rb	//you can restart through vendor/server not site option
While restarting the server, see the logfile are passed correctly in production server
Note:-
Check whether Report log started/No Error message/ Server started
Finallly check in the license file,
>> ci -u license.dat
Now license is successfully installed.

