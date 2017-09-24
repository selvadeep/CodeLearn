ALDB service and Credential Manager service stopped in clearcase

1.	First need to check in clearcase properties to know the status of services like started,running and stopped.
To open clearcase properties follow the given steps,
Open 'Run' command Window -> Then type 'cc.cpl'
2.	If ALDB service has been stopped please check the logon credntials of clearcase. Check whether updated new username and password in logon credentials, if not need to update new credentials.

To see the all services status list in windows please follow the given steps
	a .	Opend 'Run' command window -> Type 'services.msc'
				or
	b.	Open 'Task manager' -> Click the 'services' tab
From the services list, you can see 'Arial Location Broker' -> Right click on the 'Arial Location Broker' -> Click the 'Properties' -> Click the 'Logon' -> from here you can change/check the username and password of clearcase logon credentials.
3.	From the services list, you can see 'Rational Credential Manager' -> Right click on the option, if the services is stopped and start the services(Right click on the option and click the start option) 

The selected version is not accessible from this view in clearcase or window share is not accessible in clearcase(clearcase will not able to mount the view)

1.	If selected version is not able to acees(check-in, check-out and undo check-out) from the view, first of all find a path of view(ask customer to give the path of view). Once they given the path or you find the path,
2.	Next you have to find the view under which server like wadcc02 server,wadcc03 server. To see the path of view under which serve need to follow given steps,
	Open the 'Run' command window the type 'lsview viewname'(this will show the where the view is created/where view is created under which server)
			(OR)
	Go to client PC -> Right click on view name folder -> click the properties(from here you can the where view is created/where view is created under which server)
3.	Now you found the where the view is created under which server, then login to that server -> Go to the particular view(what customer given path) -> now you can do check-in,check-out and undo check-out operations.

Note:-
The problem is you should check-in,check-out and undo check-out only the view is created under which server. You cannot check-in,check-out and undo check-out any other server.

More about Clearcase 

http://www.yolinux.com/TUTORIALS/ClearcaseCommands.html

What is mean by clearcase?
Version management tool for all types of files and directories,
    - records all actions
   - reports history
   - accurate reproduction of every release
Two user interfaces,
1.	command line: 'cleartool'
2.	graphical: 'xclearcase'
		
Basic Concepts:-
1.	VOB(Versioned Object Base)
A Versioned Object Base (VOB) is a centralized database that stores version information about the files and folders in a software configuration management (SCM) system.
The whole database consist of several VOBs
2.	CONFIG SPEC
Configuration specification(file) that defines what version of each VOB element you see in your view.
3.	VIEW
A working area from where you have access to the VOB.
Each individual developer or closely coordinated group has
  an own view.
4.	ELEMENT
File or Directory that is stored in a VOB

 
Basic actions for an element
A.	Checkout
A new editible version is created
Only one person can edit the file at the same time
B.	Checkin
The version that was created by checkout command is saved to the VOB and is then visible to the other views 
The element changes to write-protected mode
C.	Uncheckout 
Undo operation for checkout
Branching:
Branching:-
Allow parallel development between two developers and later merge the code.
Create a new version of the software with different features for a specific purpose.
Add features in a separate branch to be merged in later after it is proven. The benefit is to allow the main branch to continue without being disturbed.

clearhomebase:-

Open ClearCase Home Base (Start > Run type clearhomebase)
Select the Options tab
Click User Preferences
To make checkouts unreserved by default, uncheck the Reserved box under the Check Out section and click OK.
 

Reserved checkout and Un Reserved checkout
Reserved checkout:-
Once you reserved a view, other people cannot able to access the view once he checked in.
Un Reserved checkout:-
Anyone can access the view at any time.
Snapshot and Dynamic view
Snapshot view:-
Taking the mirror copy of original view but the mirror copy is saved in localhost.
Dynamic view:-
Directly you can work on the original view.
Build:-
Once all changes are checked in then finally the build operaions. Build operations can find the 

	





