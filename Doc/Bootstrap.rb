Bootstrap:-
1.	width=device-width
To ensure proper rendering and touch zooming, add the following <meta> tag inside the <head> element:
<meta name="viewport" content="width=device-width, initial-scale=1">
The width=device-width part sets the width of the page to follow the screen-width of the device (which will vary depending on the device).

The initial-scale=1 part sets the initial zoom level when the page is first loaded by the browser.
2.	Containers 
Bootstrap also requires a containing element to wrap site contents.

There are two container classes to choose from:

The .container class provides a responsive fixed width container
The .container-fluid class provides a full width container, spanning the entire width of the viewport
Note: Containers are not nestable (you cannot put a container inside another container).

3.	Grid System
Bootstrap's grid system allows up to 12 columns across the page.
The Bootstrap grid system has four classes:

xs (for phones)
sm (for tablets)
md (for desktops)
lg (for larger desktops)
4.	Default Settings
Bootstrap's global default font-size is 14px, with a line-height of 1.428.

This is applied to the <body> and all paragraphs.

In addition, all <p> elements have a bottom margin that equals half their computed line-height (10px by default).
5.	Table
The .table-responsive class creates a responsive table. The table will then scroll horizontally on small devices (under 768px). When viewing on anything larger than 768px wide, there is no difference
.table class adds basic styling to a table
.table-striped class adds zebra-stripes to a table
.table-bordered class adds borders on all sides of the table and cells
.table-hover class enables a hover state on table rows
.table-condensed class makes a table more compact by cutting cell padding in half
Contextual classes can be used to color table rows (<tr>) or table cells (<td>)
The contextual classes that can be used are:

Class - Description
.active - Applies the hover color to the table row or table cell
.success - Indicates a successful or positive action
.info - Indicates a neutral informative change or action
.warning - Indicates a warning that might need attention
.danger	 - Indicates a dangerous or potentially negative action
6.	Image
.img-responsive - class applies display: block; and max-width: 100%; and height: auto; to the image
Image shapes,
a. img-rounded
b. img-circle
c. img-thumbnail
7.	Responsive Embeds
Also let videos or slideshows scale properly on any device.
Classes can be applied directly to <iframe>, <embed>, <video>, and <object> elements.
The following example creates a responsive video by adding an .embed-responsive-item class to an <iframe> tag (the video will then scale nicely to the parent element). 
Eg:-
<div class="embed-responsive embed-responsive-16by9">
  <iframe class="embed-responsive-item" src="..."></iframe>
</div>
8.	Jumbotron
A jumbotron indicates a big box for calling extra attention to some special content or information.A jumbotron is displayed as a grey box with rounded corners.
<div class="container">
a. Jumbotron Inside Container
b. Jumbotron Outside Container
http://www.w3schools.com/bootstrap/bootstrap_jumbotron_header.asp
9.	page-header
page-header - adds a horizontal line under the heading.
10.	Wells
The .well class adds a rounded border around an element with a gray background color and some padding
http://www.w3schools.com/bootstrap/bootstrap_wells.asp
11.	Alerts
.alert-success, .alert-info, .alert-warning or .alert-danger
12. 	Button
Button styles,
	btn-default,btn-primary,btn-success,btn-info,btn-warning,btn-danger,btn-link
Button sizes,
	btn-lg,btn-md,btn-sm,btn-xs
Block level buttons,
	btn-block
Active/Disabled Buttons,
	active,disabled
Button Groups
	Bootstrap allows you to group a series of buttons together (on a single line) in a button group,
btn-group,btn-group-vertical,btn-group-justified
13. 	Glyphicons
Bootstrap provides 260 glyphicons from the Glyphicons Halflings set.
<span class="glyphicon glyphicon-name"></span>
14.	Badges
Badges are numerical indicators of how many items are associated with a link:
News 5
15.	Label
.label class,  followed by one of the six contextual classes .label-default, .label-primary, .label-success, .label-info, .label-warning or .label-danger
16.	
