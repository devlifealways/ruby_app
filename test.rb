#!/usr/bin/env ruby

require 'digest'
def secure_hash string
   salt = secure_hash("#{Time.now.utc}--#{string}")
   again = secure_hash("#{Time.now.utc}--#{salt}")	   
   Digest::SHA2.hexdigest again
end


p "Launching the test : "
p secure_hash "Phoenix"



