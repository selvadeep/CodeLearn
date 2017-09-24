#!/usr/bin/env ruby
require "rubygems"
require "bundler/setup"
require "mailman"
#Mailman.config.logger = Logger.new("log/mailman.log")  # uncomment this if you can want to create a log file
Mailman.config.poll_interval = 3  # change this number as per your needs. Default is 60 seconds
Mailman.config.pop3 = {
  server: 'hcl.com', port: 995, ssl: true,
  username: "selvaganapathi.m",
  password: "password2!"
}
  Mailman::Application.run do
  default do
    begin
    p "Found a new message"
    p message.from.first # message.from is an array
    p message.to.first # message.to is an array again..
    p message.subject
    rescue Exception => e
puts "######################################3"
    end
  end
end