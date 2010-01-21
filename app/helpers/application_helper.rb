# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def user_field(name, options = {:size => 16}, selected = nil)
    # select object_name, method, User.find(:all, :conditions => { :active => true}).sort{|a,b| a.to_label <=> b.to_label}.collect{ |a| [a.to_label, a.id] }, {:size => options[:size], :include_blank => true}, :selected => (selected.nil? ? nil : selected.id)
    options = User.find(:all, :conditions => { :active => true}).sort{|a,b| a.to_label <=> b.to_label}.collect{|a| "<option value='#{a.id}' #{(!selected.nil? && selected==a) ? 'selected=true' : ''}>#{a.to_label}</option>"}.join("")
    select_tag name, "<option value='' #{selected.nil? ? 'selected=true' : ''}></option>" + options
  end
  
  def adminMode?
    session[:admin_mode]
  end
end
