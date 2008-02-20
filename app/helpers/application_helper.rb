# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def user_field(object_name, method, options = {:size => 16})
    select object_name, method, User.find(:all, :conditions => { :active => true}).sort{|a,b| a.to_label <=> b.to_label}.collect{ |a| [a.to_label, a.id] }, :size => options[:size]
  end
end
