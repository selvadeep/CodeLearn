require 'rubygems'
require 'net/ldap'

ldap = Net::LDAP.new
ldap.host = "adldap.cos.agilent.com"
ldap.port = 389
ldap.auth "semuruga","passwd" #"flexcls","passwd" "anisamym", "Setools@02"
if ldap.bind
  puts "authentication succeeded"
else
  puts "authentication failed"
end


##############################################################################3


 require 'net/ldap' # gem install ruby-net-ldap

    class ActiveDirectoryUser
      ### BEGIN CONFIGURATION ###
      SERVER = "adldap.cos.agilent.com"   # Active Directory server name or IP
      PORT = 389                    # Active Directory server port (default 389) 636
      BASE = "DC=agilent,DC=com"    # Base to search from  DC=ldap,DC=it,DC=agilent,DC=com
      DOMAIN = "non.agilent.com"        # For simplified user@domain format login
      ### END CONFIGURATION ###

      def self.authenticate(login, pass)
        return false if login.empty? or pass.empty?
        #puts login
        #puts pass
        
        
    $relative_to = 5000; 
        conn = Net::LDAP.new :host => SERVER,
                             :port => PORT,
                             :base => BASE,
                             
                             :auth => { :username => "#{login}@#{DOMAIN}", 
                                        :password => pass,
                                        :method => :simple }
puts "#{login}@#{DOMAIN}"
puts pass
        if conn.bind
          puts "true"
        else
          puts "false"
        end
      # If we don't rescue this, Net::LDAP is decidedly ungraceful about failing
      # to connect to the server. We'd prefer to say authentication failed.
      rescue Net::LDAP::LdapError => e
        return false
      end
    end
    
    ActiveDirectoryUser.authenticate("murali_arimuthu","OMMuruga@123")  #"flexcls","passwd"
    
    
  
  
  ####################################################################
  
  



