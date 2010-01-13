class Setting < ActiveRecord::Base
  validates_presence_of :key
  validates_presence_of :value
  
  validates_uniqueness_of :key
  
  def self.get(key)
    res = Setting.find(:all, :conditions => "key == '#{key}'")
    if(res.length==1)
      #puts "found setting: #{res[0].key} => #{res[0].value}"
      return res[0].value
    else
      #puts "could not find setting: #{key}"
      return ""
    end
  end
  
  def self.set(key, value)
    res = Setting.find(:all, :conditions => "key == '#{key}'")
    if(res.length==1)
      res[0].value = value
      res[0].save
    elsif (res.length==0)
      s = Setting.new
      s.key = key
      s.value = value
      s.save
    end
  end
  
  def self.print_all
    settings = Setting.find(:all)
    for setting in settings
      puts "#{setting.key} => #{setting.value}"
    end
  end
end