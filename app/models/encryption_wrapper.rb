require 'lib/security_helpers'

class EncryptionWrapper
   def initialize(attribute)
     @attribute = attribute
   end

   def before_save(record)
     @attribute.each{|a| record.send("#{a}=", encrypt(record.send("#{a}"))) }
   end

   def after_save(record)
     @attribute.each{|a| record.send("#{a}=", decrypt(record.send("#{a}"))) }
   end

   alias_method :after_find, :after_save

   private
     def encrypt(value)
       if(value)
         unless(value.starts_with?("#_"))
           "#_#{encrypt_string(value)}"
         else
           value
         end
       end
     end

     def decrypt(value)
        if(value&&value.starts_with?("#_"))
          decrypt_string(value[2..(value.length-1)])
        else
          value
        end
     end
end
