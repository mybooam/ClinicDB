class DrugController < ApplicationController
	active_scaffold :drug do |config|
		config.columns = [:name]
	end
	
	def test_new_drug
	  s = params[:drug][:name]
    flash[:notice] = Drug.from_user_string(s)
	  
	  redirect_to :action => 'test_drug'
  end
  
  def live_search
	    max_listing = 15
      post_sections = request.raw_post.split('&')
      if(post_sections.length>1)
        phrases = post_sections[0].split('%20')
      
        query_any = phrases.collect { |a|
          "(name LIKE '%#{a}%')"
        }.join(" OR ")
        
        query_all = phrases.collect { |a|
          "(name LIKE '%#{a}%')"
        }.join(" AND ")
      
        @results_all = Drug.find(:all, :conditions => query_all).sort{|a, b| a.name <=> b.name}
        @results_any = Drug.find(:all, :conditions => query_any).sort{|a, b| a.name <=> b.name}
        
        @results = (@results_all + @results_any).uniq
      end  

      render(:layout => false)
  end
end
