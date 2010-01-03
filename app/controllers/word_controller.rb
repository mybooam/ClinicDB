class WordController < ApplicationController
  def list
    @words = []
    patients = Patient.find(:all)
    
    for pat in patients do
      puts "#{pat.to_label}"
      if pat.adult_illness!=nil
        cur_words = pat.adult_illness.split(%r{\W+})
        puts cur_words.join(",")
        for word in cur_words do
          found = @words.find{ |a| a[:word_str]==word }
          if found == nil
            puts "#{word} not found"
            @words << {:word_str => word, :count => 1, patinets}
          else
            puts "#{word} found"
            found[:count] = found[:count] + 1
          end
        end
      end
    end
    
    @words.sort! {|a,b| b[:count] <=> a[:count]}
  end
end