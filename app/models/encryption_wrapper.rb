require 'lib/security_helpers'

class EncryptionWrapper
   def self.for_class(class_name)
     EncryptionWrapper.new(EncryptionWrapper.attributes_for_class(class_name))
   end
   
   def self.attributes_for_class(class_name)
     eval "#{class_name}.columns.select{ |c| c.text?}.collect{ |c| c.name }"
   end
   
   def initialize(attributes, class_name = nil)
     @attributes_to_encrypt = @attributes_to_decrypt = attributes
     if class_name
       @attributes_to_decrypt = EncryptionWrapper.attributes_for_class(class_name)
       puts @attributes_to_decrypt.join(" ")
     end
   end

   def before_save(record)
     @attributes_to_encrypt.each{|a| record.send("#{a}=", encrypt(record.send("#{a}"))) }
   end

   def after_save(record)
     @attributes_to_decrypt.each{|a| record.send("#{a}=", decrypt(record.send("#{a}"))) }
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
