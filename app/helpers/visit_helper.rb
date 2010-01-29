module VisitHelper
	def options_for_association_conditions(association)
    if association.name == :users
      "active='t'"
    else
      super
    end
  end
  
  def hp_label(column_name)
    column_name.split('_',2)[1].split('_').collect{|a| a.downcase == "and" ? "/" : a }.collect{|a| a =~ /^[a-z]*$/ ? a.capitalize : a }.join(' ')
  end
  
  def hp_field_tag(column_name, opts={})
    opts.reverse_merge! :na_value => 'n/a', :neg_value => 'wnl', :abn_value => 'abn', :show_checkbox_labels => false
    opts.reverse_merge! :column_name => column_name
    render :partial => '/visit/hp_line', :locals => opts
  end
end
