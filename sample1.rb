require 'net/smtp'
require 'rmail'
# require 'args' # should be pulled in by main program requiring eltconfig

########################################################################
#
# :title: eltmail.rb
#
# == Synopsis
# === Purpose
#
# This module defines the ELTmail namespace, which provides methods
# for sending email with or without file attachments.
#
# One of the module methods is ELTmail.send_ovsd_email(), which is used to
# programmatically open an OVSD ticket.
#
# === Implementation Details
# 
# The RubyMail module is used to assemble MIME type messages in the required
# format so that SendMail will properly process them.
# RubyMail 1.0.0 was obtained from http://rubyforge.org/projects/rubymail/
#
# To eliminate a warning about @delimiters not being initialized, from
# line 191 of RubyMail's message.rb file, I modified that file and added the
# line '@delimiters=nil' to the constructor.
#
# On samtest.soco, the new Linux machine, I installed the rmail ruby gem with
# 	gem install rmail
# Using it with ruby -w gave several warnings from address.rb, header.rb, and
# message.rb.  I tweaked those 3 files and was able to eliminate the warnings.
#
# Ruby's standard library net/smtp is used to communicate with a mail server.
#
# == Usage
#
# Add the module directory to the Ruby search path:
#
#	require '/opt/elt/lib/setenv.rb'
#
# Require the module:
#
#       require 'eltmail'
#
# Instantiate a Mail object:
#
#	mymail=ELTmail::Mail.new
#
# You can supply to, from, subject, etc. in an argument hash to the constructor
# or by using the methods of those names.
#
# You can attach files to send using the attach_file() method.
#
# Use the send() method to mail the assembled email.
#
# == Author
#
# Ken Laird, Technical Computing, Agilent Technologies
#
# == Copyright
#
#  Copyright (c) 2010 by Kenneth R. Laird (ken_laird@agilent.com)
#
#  This is free software; you can redistribute it and/or modify it
#  under the terms of the GNU General Public License as published by
#  the Free Software Foundation; version 2, or (at your option) any
#  later version.
# ---
#
# == File Information
#
# <b>Server</b>:: sam.cos.agilent.com
# <b>Test Location</b>:: /opt/elt/devel/lib/eltmail.rb
# <b>Production Location</b>:: /opt/elt/lib/eltmail.rb
# <b>Language</b>:: Ruby
#--
#  To generate RDOC documentation:
#
#     /usr/local/bin/rdoc -a 
#	-o /home/flexcls/src/docs/eltmail_doc eltmail.rb
#++
########################################################################

module ELTmail

#--
##################################################################
##################################################################
##								##
##  Module Constants						##
##								##
##################################################################
##################################################################
#++
 
# Agilent SMTP relay
AGI_MAIL_SERVER="cos.smtp.agilent.com"
ELTCOMPANY="Agilent"

# Keysight SMTP relay
KEY_MAIL_SERVER="smtp.cos.is.keysight.com"

# Where to send the email so it will get automagically turned into an
# OVSD case.
AGI_OVSD_TO_ADDRESS="sm_prod@agilent.com"
KEY_OVSD_TO_ADDRESS="sm_prod@keysight.com"

# Who to show as the From address
AGI_OVSD_FROM_ADDRESS="es-ops-elt.pdl-it@agilent.com"
KEY_OVSD_FROM_ADDRESS="siew-wing_cheang@keysight.com"

# Part of the OVSD boilerplate
OVSD_SERVICE="Ent App-Central License Server"

# OVSD's cryptic designation of our queue
ELT_WORKGROUP="Central Engineering Licensing Server Support"

# More OVSD boilerplate
OVSD_SENDERID="RDEM-CLS"
AGI_OVSD_CONFIGITEM="cos-borg.cos.agilent.com"
KEY_OVSD_CONFIGITEM="ymir.cos.is.keysight.com"

AGI_OVSD_CALLERNAME="HELMUT BRAIG"
KEY_OVSD_CALLERNAME="SIEW-WING CHEANG"
AGI_OVSD_CALLERID="00105214"
KEY_OVSD_CALLERID="00479135"

#--
##################################################################
##################################################################
##								##
##  Module Functions						##
##								##
##################################################################
##################################################################
#++

#--
#########################################
# add_confidential function		#
#########################################
#++
# Prepends a <COMPANY> CONFIDENTIAL notice to an HTML file.   The
# file is rewritten in place.  At this time, the argument hash only
# accepts one key: 'filename'.
#
# ====Parameters
# <b>arg_hash</b>::
# 	Hash of keys and values described above
# ====Returns
# <b>result</b>::
#	True on success or False on failure.

def add_confidential(arg_hash)
  if not arg_hash.instance_of? Hash
    STDERR.puts "Programming ERROR: ELTmail.add_confidential requires a Hash"
    exit 1
  end
  args=ELTargs::Args.new(arg_hash)
  begin
    args.validate({"filename"=>"s"})
  rescue ArgumentError => ex
    STDERR.puts "Programming ERROR: ELTmail.add_confidential: invalid arguments"
    STDERR.puts ex.message
    exit 1
  end
  filename=args["filename"]

  begin
    lines=IO.readlines(filename)
  rescue Exception => ex
    STDERR.puts "ERROR: ELTmail.add_confidential unable to read #{filename}"
    STDERR.puts ex.message
    return false
  end

  begin
    fh=File.open(filename,"w")
    lines.each do |line|
      if line=~/<\s*(body|BODY)/
	fh.write(line+
	   "<center><h2><font color=\"red\"><I>(#{ELTCOMPANY.upcase} "+
	   "CONFIDENTIAL)</I></font></h2></center>\n")
      else
	fh.write(line)
      end
    end
    fh.close
  rescue Exception => ex
    STDERR.puts "ERROR: ELTmail.add_confidential unable to rewrite #{filename}"
    STDERR.puts ex.message
    return false
  end

  return true
end # add_confidential

# Makes function accessible with . instead of ::
module_function :add_confidential

#--
#########################################
# send_ovsd_email function		#
#########################################
#++
# Assembles an email message with all of the required OVSD boilerplate
# and formatting and sends it to the email alias that acts as an
# API to the OVSD mail interface.  The keys and values required in
# the argument hash are:
# <b>desc</b>::
# 	The synopsis line (description) for the ticket.
# <b>info</b>::
# 	The ticket details
# <b>subj</b>::
# 	A subject line for the message.
# <b>cc_list</b>::
# 	Optional Array of email addresses of people to be copied on 
# 	the message.
# <b>impact</b>::
# 	Optional problem impact.  Acceptable values are:
# 	"2 - Site/Dept" (default), "3 - Multiple Users", and
# 	"4 - User".  There is also a "1 - Enterprise", but we will
# 	never use that.
# <b>ctgy</b>::
# 	Optional <Category> string.  Defaults to ELT value.
# <b>area</b>::
# 	Optional <Area> string.  Defaults to ELT value.
# <b>subarea</b>::
# 	Optional <Subarea> string.  Defaults to ELT value.
# <b>group</b>::
# 	Optional <AssignmentGroup> string.  Defaults to ELT value.
# <b>empno</b>::
# 	Optional <CallerID> string.  Defaults to ELT value.
# <b>caller</b>::
# 	Optional <CallerName> string.  Defaults to ELT value.
# <b>email</b>::
# 	Optional <CallerEmail> string.  Defaults to ELT value.
# <b>company</b>::
# 	Optional <IssueCompany> string.  Defaults to Agilent.
#
# ====Parameters
# <b>arg_hash</b>::
# 	Hash of keys and values described above
# ====Returns
# <b>result</b>::
#	True on success or False on failure.

def send_ovsd_email(arg_hash)
  if not arg_hash.instance_of? Hash
    STDERR.puts "Programming ERROR: ELTmail.send_ovsd_email requires a Hash"
    exit 1
  end
  args=ELTargs::Args.new(arg_hash)
  begin
    args.validate({"desc"=>"s",
    		   "info"=>"s",
    		   "subj"=>"s",
    		   "cc_list"=>"a:",
    		   "impact"=>"s:",
    		   "ctgy"=>"s:",
    		   "area"=>"s:",
    		   "subarea"=>"s:",
    		   "group"=>"s:",
    		   "empno"=>"s:",
    		   "caller"=>"s:",
    		   "email"=>"s:",
    		   "company"=>"s:"})
  rescue ArgumentError => ex
    STDERR.puts "Programming ERROR: ELTmail.send_ovsd_email: invalid arguments"
    STDERR.puts ex.message
    exit 1
  end

  # Set company-specific items
  if args.has_key?("company")
    company=args["company"]
  else
    company=ELTCOMPANY
  end
  if company=="Keysight"
    ovsd_to_address=KEY_OVSD_TO_ADDRESS
    ovsd_from_address=KEY_OVSD_FROM_ADDRESS
    ovsd_configitem=KEY_OVSD_CONFIGITEM
    ovsd_callername=KEY_OVSD_CALLERNAME
    ovsd_callerid=KEY_OVSD_CALLERID
    # SM9 is expected to be separated by 3:30 MST on Feb 8 2015
    cutover=Time.local(2015,2,8,3,30,0,0)
    now=Time.now
    if now>cutover
      request_company="KeysightRequest"
    else
      request_company="AgilentRequest"
    end
  else
    ovsd_to_address=AGI_OVSD_TO_ADDRESS
    ovsd_from_address=AGI_OVSD_FROM_ADDRESS
    ovsd_configitem=AGI_OVSD_CONFIGITEM
    ovsd_callername=AGI_OVSD_CALLERNAME
    ovsd_callerid=AGI_OVSD_CALLERID
    request_company="AgilentRequest"
  end

  # Assemble the message to be sent to the OVSD system and the message
  # to be sent to the CC addressees.
  ovsdtext=""
  cctext=""
  epochsecs=Time.new.to_i

  ovsdtext << "<?xml version=\"1.0\"?>\n"
  ovsdtext << "<#{request_company}>\n"
  if args.has_key?("ctgy")
    ovsdtext << "<Category>#{args['ctgy']}</Category>\n"
  else
    # ovsdtext << "<Category>Engineering Tools and Engagement</Category>\n"
    ovsdtext << "<Category>Engineering Tools and Applications</Category>\n"
  end
  if args.has_key?("area")
    ovsdtext << "<Area>#{args['area']}</Area>\n"
  else
    ovsdtext << "<Area>Engineering Licensing</Area>\n"
  end
  if args.has_key?("subarea")
    ovsdtext << "<Subarea>#{args['subarea']}</Subarea>\n"
  else
    ovsdtext << "<Subarea>Central Engineering License Server</Subarea>\n"
  end
  if args.has_key?("impact")
    ovsdtext << "<Impact>#{args['impact']}</Impact>\n"
  else
    ovsdtext << "<Impact>2 - Site/Dept</Impact>\n"
  end
  ovsdtext << "<Title>#{args['desc']}</Title>\n"
  ovsdtext << "<Description>#{args['info']}\n"
  ovsdtext << "</Description>\n"
  if args.has_key?("group")
    ovsdtext << "<AssignmentGroup>#{args['group']}</AssignmentGroup>\n"
  else
   ovsdtext << "<AssignmentGroup>#{ELT_WORKGROUP}</AssignmentGroup>\n"
  end
  # ovsdtext << "<CaseType>Incident Request</CaseType>\n"
  ovsdtext << "<CaseType>Service Request</CaseType>\n"
  if args.has_key?("empno")
    ovsdtext << "<CallerID>#{args['empno']}</CallerID>\n"
  else
    ovsdtext << "<CallerID>#{ovsd_callerid}</CallerID>\n"
  end
  if args.has_key?("caller")
    ovsdtext << "<CallerName>#{args['caller']}</CallerName>\n"
  else
    ovsdtext << "<CallerName>#{ovsd_callername}</CallerName>\n"
  end
  if args.has_key?("email")
    ovsdtext << "<CallerEmail>#{args['email']}</CallerEmail>\n"
  else
    ovsdtext << "<CallerEmail>#{ovsd_from_address}</CallerEmail>\n"
  end
  if args.has_key?("company")
    ovsdtext << "<IssueCompany>#{args['company']}</IssueCompany>\n"
  else
    ovsdtext << "<IssueCompany>Agilent</IssueCompany>\n"
  end
  ovsdtext << "<ConfigurationItem>#{ovsd_configitem}</ConfigurationItem>\n"
  ovsdtext << "<ExternalCaseNumber>#{epochsecs}</ExternalCaseNumber>\n"
  # ovsdtext << "</AgilentRequest>\n"
  ovsdtext << "</#{request_company}>\n"

  cctext << "OVSD ticket created:    #{args['desc']}\n\n"
  cctext << "Ticket created by:      #{$0}\n\n"
  cctext << "Ticket information:\n"
  cctext << "#{args['info']}\n\n"
  cctext << "************ OVSD EMAIL CONTENT SUBMITTED **********\n"
  cctext << ovsdtext

  ovsdmail=ELTmail::Mail.new({"from"=>ovsd_from_address,
			      "to"=>ovsd_to_address,
			      "subject"=>args['subj'],
			      "text"=>ovsdtext})
  if not ovsdmail.send
    STDERR.puts "ERROR: ELTmail.send_ovsd_email failed to open ticket."
    return false
  end

  if args.has_key?("cc_list")
    ccmail=ELTmail::Mail.new({"from"=>ovsd_from_address,
			      "to"=>args["cc_list"],
			      "subject"=>args['subj'],
			      "text"=>cctext})
    if not ccmail.send
      STDERR.puts "WARN: ELTmail.send_ovsd_email failed to send CC msg."
    end
  end

  return true
end # send_ovsd_email

# Makes function accessible with . instead of ::
module_function :send_ovsd_email

#--
##################################################################
##################################################################
##								##
##  Module Classes						##
##								##
##################################################################
##################################################################
#++

#--
########################################
# Mail class
########################################
#++
# The Mail class encapsulates the elements of an email message
# along with methods to add elements and send the message.

class Mail

  # A host running an SMTP server.  It is initialized to AGI_MAIL_SERVER
  # or KEY_MAIL_SERVER but can changed by the calling program.
  attr_accessor :mail_server

  # The RMail object that is assembled and will be sent
  attr_reader :message

  # Addressee(s).  A string or array of strings.
  # attr_accessor :to

  # The email address to appear as the sender
  # attr_accessor :from

  # The subject string
  # attr_accessor :subject
  
  # Boolean telling if body text is HTML (true) or plain text
  # (false) (default).
  attr_reader :html

  # The message element separator string
  attr_reader :marker

  # An array of RMail::Message objects that will be assembled
  # into the message body before sending.
  attr_reader :msg_parts

  #--
  #######################################
  # initialize (constructor) method  	#
  #######################################
  #++
  # Constructor - Initializes attributes.  Takes an optional
  # argument hash, which, if supplied, must include the following:
  # <b>from</b>::
  # 	The email address of the sender
  # <b>to</b>::
  # 	The email address of the addressee, or an array of 
  # 	addresses, if more than one.
  # <b>subject</b>::
  # 	Self explanatory
  # <b>text</b>::
  # 	The message body
  # <b>html</b>::
  # 	Optional boolean set to true if the message body is
  # 	HTML text.
  # 
  # ====Parameters
  # <b>arg_hash</b>::
  # 	Optional hash of keys and values described above

  def initialize(arg_hash=nil)
    if ELTCOMPANY=="Agilent"
      @mail_server=AGI_MAIL_SERVER
    else
      @mail_server=KEY_MAIL_SERVER
    end
    @to=nil
    @from=nil
    @subject=nil
    @html=false
    srand Time.new.to_i
    @marker=sprintf("__ELTmail%d",(rand*10**12).to_i)
    @msg_parts=Array.new
    @message=RMail::Message.new
    @message.header['MIME-Version'] = "1.0"
    @message.header.add('Content-Type', 'multipart/mixed', nil,
              		'boundary' => @marker)
    @message.header.add_message_id

    if arg_hash==nil
      return
    end

    # I am not using Args to validate the arg_hash because the
    # 'to' element can be either a string or an array of strings.
    if arg_hash.has_key?("from")
      from(arg_hash["from"])
    else
      STDERR.puts "ELTmail::Mail: Programming error: 'from' is required"
      exit 1
    end
    if arg_hash.has_key?("to")
      to(arg_hash["to"])
    else
      STDERR.puts "ELTmail::Mail: Programming error: 'to' is required"
      exit 1
    end
    if arg_hash.has_key?("subject")
      subject(arg_hash["subject"])
    else
      STDERR.puts "ELTmail::Mail: Programming error: 'subject' is required"
      exit 1
    end
    if arg_hash.has_key?("html")
      @html=arg_hash["html"]
    end
    if arg_hash.has_key?("text")
      body(arg_hash["text"],@html)
    else
      STDERR.puts "ELTmail::Mail: Programming error: 'text' is required"
      exit 1
    end
  end # constructor

  #--
  #######################################
  # attach_file method  		#
  #######################################
  #++
  # Attaches a file to the message.  The allowed types are
  # "binary" or "text".  I may add "html" in the future if there
  # is a need to inline HTML.  Otherwise, HTML files can simply
  # be attached as "binary" type.   Files that are specified as
  # binary get base64 encoded for transmission.  Mail readers
  # automatically unencode at the destination.
  #
  # This method takes an argument hash with the following
  # keys and values:
  # <b>path</b>::
  # 	The actual path to the file to be included
  # <b>name</b>::
  # 	What the file should be named in the message.  Include
  # 	suffixes such as .html or .txt so the mail reader knows
  # 	what to launch to read the attachment.
  # <b>type</b>::
  # 	"binary" or "text".  Defaults to "binary".
  # 
  # ====Parameters
  # <b>arg_hash</b>::
  # 	Hash of keys and values describe above
  # ====Returns
  # <b>none</b>::

  def attach_file(arg_hash)
    if not arg_hash.instance_of? Hash
      STDERR.puts "Programming ERROR: Mail::attach_file requires a Hash argument."
      exit 1
    end
    args=ELTargs::Args.new(arg_hash)
    begin
      args.validate({"path"=>"s","name"=>"s","type"=>"s:"})
    rescue ArgumentError => ex
      STDERR.puts "Programming ERROR: Mail::attachfile invalid arguments."
      STDERR.puts ex.message
      exit 1
    end

    type = args.has_key?("type") ? args["type"].downcase : "binary"
    if type!="binary" and type!="text"
      STDERR.puts "Programming ERROR: Mail::attachfile type error."
      STDERR.puts " 'binary' or 'text' required at this time."
      exit 1
    end

    # Load the file into memory
    begin
      filecontent=File.read(args['path'])
    rescue Exception => ex
      STDERR.puts "ERROR: Mail::attachfile unable to read #{path}"
      STDERR.puts ex.message
      exit 1
    end

    filepart=RMail::Message.new
    filepart.header['Content-Disposition']=
      "attachment; filename=\"#{args['name']}\""

    # base64 encode files designated as "binary"
    if type=="binary"
      encoded_content=[filecontent].pack("m")
      filepart.header.add('Content-Type','application/octet-stream',
			  nil,'boundary'=>@marker)
      filepart.header['Content-Transfer-Encoding']="base64"
    else # text
      encoded_content=filecontent
      filepart.header.add('Content-Type','text/plain',
			  nil,'boundary'=>@marker)
      filepart.header['Content-Transfer-Encoding']="binary"
    end
    filepart.body=encoded_content
    @msg_parts << filepart
  end # attach_file

  #--
  #######################################
  # bcc method  			#
  #######################################
  #++
  # Stores the provided email address(es) in the @bcc
  # attribute and the message header.  Blows up the program
  # if passed something other than a string or array of strings
  # that look like an email address. 
  # 
  # ====Parameters
  # <b>who</b>::
  # ====Returns
  # <b>none</b>::
  # 	Adds the To element to the message header

  def bcc(who)
    if not valid_address(who,"bcc")
      exit 1
    end
    @bcc=who
    @message.header.bcc=@bcc
  end # bcc

  #--
  #######################################
  # body method  			#
  #######################################
  #++
  # Constructs a text element for the message using the
  # body text provided.  The text argument should be a
  # string, with or without embedded line breaks.
  # 
  # ====Parameters
  # <b>text</b>::
  # 	The message body text. Required.
  # <b>html</b>::
  # 	Optional boolean.  True=body is HTML text.
  # 	False (default) = body is plain text.
  # ====Returns
  # <b>none</b>::
  # 	Adds the text element to @msg_parts

  def body(text,html=false)
    textpart=RMail::Message.new
    if html
      textpart.header.add('Content-Type', 'text/html', nil,
              		'boundary' => @marker)
    else
      textpart.header.add('Content-Type', 'text/plain', nil,
              		'boundary' => @marker)
    end
    textpart.header['Content-Transfer-Encoding']="8bit"
    textpart.body=text
    @msg_parts << textpart
  end # body

  #--
  #######################################
  # cc method  				#
  #######################################
  #++
  # Stores the provided email address(es) in the @cc
  # attribute and the message header.  Blows up the program
  # if passed something other than a string or array of strings
  # that look like an email address. 
  # 
  # ====Parameters
  # <b>who</b>::
  # ====Returns
  # <b>none</b>::
  # 	Adds the To element to the message header

  def cc(who)
    if not valid_address(who,"cc")
      exit 1
    end
    @cc=who
    @message.header.cc=@cc
  end # cc

  #--
  #######################################
  # from method  			#
  #######################################
  #++
  # Stores the provided email address in the @from 
  # attribute and the message header.  Blows up the program
  # if passed something other than a string that looks like
  # an email address. 
  # 
  # ====Parameters
  # <b>who</b>::
  # 	String sender email address.
  # ====Returns
  # <b>none</b>::
  # 	Adds the From element to the message header

  def from(who)
    if not who.instance_of? String
      STDERR.puts "ELTmail::Mail: from ERROR: requires a String"
      exit 1
    end
    if not who=~/^\S+\@\S+/
      STDERR.puts "ELTmail::Mail: from ERROR: not a valid email address"
      exit 1
    end
    @from=who
    @message.header.from=@from
  end # from

  #--
  #######################################
  # send method  			#
  #######################################
  #++
  # Uses Ruby's net/smtp module to send the message.  
  # We automatically do a 2 second sleep after the send,
  # so that if a calling script does a lot of sends, we don't
  # overwhelm the sendmail daemon.
  # Returns true on success or false on failure.
  # 
  # ====Parameters
  # <b>none</b>::
  #
  # ====Returns
  # <b>result</b>::
  # 	True or False

  def send()
    if not @to or not @from or not @subject
      STDERR.puts "ELTmail::Mail: ERROR: Missing elements:"
      STDERR.puts "To, From, or Subject."
      return false
    end
    if @msg_parts.empty?
      STDERR.puts "ELTmail::Mail: ERROR: Missing elements:"
      STDERR.puts "No message text provided."
      return false
    end

    @message.body=@msg_parts
    begin
      Net::SMTP.start(@mail_server) do |smtp|
        smtp.send_message(@message.to_s, @from, @to)
      end
    rescue Exception => ex
      STDERR.puts "ELTmail::Mail: Error sending message."
      STDERR.puts ex.message
      return false
    end
    sleep(2)
    return true
  end # send

  #--
  #######################################
  # subject method  			#
  #######################################
  #++
  # Stores the provided string as the subject
  # attribute and part of the message header.  Blows up the program
  # if passed something other than a string.
  # 
  # ====Parameters
  # <b>subj</b>::
  # 	String subject
  # ====Returns
  # <b>none</b>::
  # 	Adds the From element to the message header

  def subject(subj)
    if not subj.instance_of? String
      STDERR.puts "ELTmail::Mail: subject ERROR: requires a String"
      exit 1
    end
    @subject=subj
    @message.header.subject=@subject
  end # subject

  #--
  #######################################
  # to method  				#
  #######################################
  #++
  # Stores the provided email address(es) in the @to
  # attribute and the message header.  Blows up the program
  # if passed something other than a string or array of strings
  # that look like an email address. 
  # 
  # ====Parameters
  # <b>who</b>::
  # ====Returns
  # <b>none</b>::
  # 	Adds the To element to the message header

  def to(who)
    if not valid_address(who,"to")
      exit 1
    end
    @to=who
    @message.header.to=@to
  end # to

  #--
  #######################################
  # valid_address method 		#
  #######################################
  #++
  # Examines the provided email address or array of email addresses.
  # Returns true if they seem to valid email addresses.
  # Returns false if they don't or are not strings.
  # 
  # ====Parameters
  # <b>who</b>::
  #	The address or array of addresses
  # <b>type</b>::
  # 	The type of address this is supposed to be, for use in the
  # 	error string.
  # ====Returns
  # <b>result</b>::
  # 	True or false

  def valid_address(who,type)
    if not who.instance_of? String and not who.instance_of? Array
      STDERR.puts "ELTmail::Mail: #{type} ERROR: requires a String or Array"
      return false
    end
    if who.instance_of? Array
      test_array=who
    else
      test_array=[who]
    end
    test_array.each do |addr|
      if not addr=~/^\S+\@\S+/
        STDERR.puts "ELTmail::Mail: #{type} ERROR: #{addr} not a valid email"
        return false
      end
    end
    return true
  end # valid_address

end # Mail class


#--
########################################
# Notification class
########################################
#++
# The Notification class is used to assemble and send an email
# message in which the body of the message is composed of a number
# of logical blocks.  Its intended use is from programs that are generating
# messages in a sequence that doesn't match the way those messages should
# be logically grouped.   An example would be a script that applies a number
# of different tests to a set of servers and wants to process each server in
# turn but to group all of the result notifications by type of test rather than
# by server.
#
# The calling program should instantiate this class, then call the add_block()
# method for each logical set of messages it wants to collect.  Messages are
# added using the << operator and specifying which block they are destined for
# by providing the index returned by the add_block() method.
#
# The Notification class is derived from the Mail class, and so inherits the
# from, to, cc, subject, etc. methods.   The send method overloads the 
# Mail class' send method and assembles the logical blocks of the message
# body before calling the base class' send.

class Notification < Mail

  # Hash of index => Array of strings
  attr_reader :blocks

  # Hash of index => caption string to precede block lines in the assembled
  # email.
  attr_reader :block_captions

  # Integer used by add_block() to assign a block index
  attr_reader :next_index

  #--
  #######################################
  # initialize (constructor) method  	#
  #######################################
  #++
  # Constructor - Initializes attributes.  Takes an optional
  # argument hash, which, if supplied, must include the following:
  # <b>from</b>::
  # 	The email address of the sender
  # <b>to</b>::
  # 	The email address of the addressee, or an array of 
  # 	addresses, if more than one.
  # <b>subject</b>::
  # 	Self explanatory
  # <b>html</b>::
  # 	Optional boolean set to true if the message body is
  # 	to be formatted as HTML text.
  # 	NOTE:  THIS OPTION IS IGNORED FOR THE TIME BEING
  # 
  # ====Parameters
  # <b>arg_hash</b>::
  # 	Optional hash of keys and values described above

  def initialize(arg_hash=nil)
    super()

    @html=false
    if arg_hash!=nil
      if arg_hash.has_key?("from")
        from(arg_hash["from"])
      end
      if arg_hash.has_key?("to")
        to(arg_hash["to"])
      end
      if arg_hash.has_key?("subject")
        subject(arg_hash["subject"])
      end
      if arg_hash.has_key?("html")
        @html=arg_hash["html"]
      end
    end

    @blocks=Hash.new
    @block_captions=Hash.new
    @next_index=0
  end # constructor

  #--
  #######################################
  # Notification::<< (append) method 	#
  #######################################
  #++
  # Add line to logical block.
  # The following keys and values allowed in the argument hash are as 
  # follows.  
  # <b>index</b>::
  #	The block index returned by add_block().	
  # <b>line</b>::
  # 	String to be added to the block
  #
  # ====Parameters
  # <b>arg_hash</b>:: hash of arguments and values described above

  def <<(arg_hash)
    if not arg_hash.instance_of? Hash
      STDERR.puts "Programming ERROR: Notification::<< requires a Hash argument."
      exit 1
    end
    args=ELTargs::Args.new(arg_hash)
    begin
      args.validate({"index"=>"i","line"=>"s"})
    rescue ArgumentError => ex
      STDERR.puts "Programming ERROR: Notification::<<: invalid arguments."
      STDERR.puts ex.message
      exit 1
    end

    index=args["index"].to_i
    if not @blocks.has_key?(index)
      STDERR.puts "Programming ERROR: Notification::<<: invalid index."
      STDERR.puts "Call add_block() before adding lines."
      exit 1
    end

    @blocks[index] << args["line"]
  end # << (append)

  #--
  #######################################
  # Notification::add_block method 	#
  #######################################
  #++
  # Starts a logical message body block and returns the index.
  # The argument hash, which is optional, may contain 1 key:
  # "caption".  The allowed keys and values are:
  #
  # <b>caption</b>::
  # 	String of text to precede this block in the message body.
  # 
  # ====Parameters
  # <b>arg_hash</b>::
  # 	Optional hash of keys and values described above
  # ====Returns
  # <b>index</b>::
  # 	The index of the logical block

  def add_block(arg_hash=nil)
    @next_index+=1
    @blocks[@next_index]=Array.new
    if arg_hash!=nil
      if arg_hash.has_key?("caption")
        @block_captions[@next_index]=String.new(arg_hash["caption"])
      end
    end
    return @next_index
  end # add_block

  #--
  #######################################
  # Notification::send method 		#
  #######################################
  #++
  # Assembles the logical blocks into a message body.   Checks for
  # required attributes like to and from.  Calls the base class'
  # send method.
  #
  # ====Parameters
  # <b>none</b>::
  # ====Returns
  # <b>result</b>::
  # 	True or False

  def send()
    if @to==nil
      STDERR.puts "Programming ERROR: Notification::send: To: not set."
      exit 1
    end
    if @from==nil
      STDERR.puts "Programming ERROR: Notification::send: From: not set."
      exit 1
    end
    if @subject==nil
      STDERR.puts "Programming ERROR: Notification::send: Subject: not set."
      exit 1
    end

    text=""
    @blocks.keys.sort.each do |i|
       if @block_captions.has_key?(i)
	 text << "  #{@block_captions[i]}:\n"
	 prefix="    "
       else
	 prefix="  "
       end
       @blocks[i].each do |line|
	 text << "#{prefix}#{line}\n"
       end
      text << "  \n"
    end
    body(text)

    return super()
  end # send

end # Notification class

end # module ELTmail
