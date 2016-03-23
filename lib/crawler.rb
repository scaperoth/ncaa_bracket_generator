require 'nokogiri'
require 'open-uri'

class Crawler
	attr_accessor :url, :team_data, :column_names
	def initialize(url)
		@url = url
		@content = ""
		@team_data = Hash.new
		@column_names = Hash.new
		columns = 0;
    
    prepend = "" 
    # counter
    i = 0
		next_column = 0;
		
		rank = 1

		# Fetch and parse HTML document
		#doc = Nokogiri::HTML(open(@url))
    doc = Nokogiri::HTML(File.open("#{Rails.root}/app/views/test/index.html.erb"))

		doc.css('table thead:first-child tr:nth-child(2) th').each do |link|
		  if columns> 11
        prepend = "ncsos_"
		  elsif columns > 8
        prepend = "str_of_sched_"
		  end
		  
			@column_names[columns] = prepend+link.content
      columns += 1
		end

		doc.css('tbody td').each do |link|
		  if next_column >= columns
		    rank += 1
		    next_column = 0
		    i = 0
		    next
		  end 
		  
		  if i > 5 && i % 2 == 0
		    i+=1
		    next
		  end
		  
			if next_column == 0
				@team_data[rank] = Hash.new
			else
		  	@team_data[rank][@column_names[next_column]] = link.content
			end
			
			next_column += 1
			i+=1
		end
	end
end