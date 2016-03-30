##
# @author Matt Scaperoth
# @email scaperoth@gmail.com
# @description This class crawls sites and parses the html data

require 'nokogiri'
require 'open-uri'

class Crawler
  attr_accessor :kp_url, :kp_team_data, :kp_column_names, :bmat_url, :bmat_team_data, :bmat_column_names, :bmat_num_columns
  def initialize()
    @kp_url = "http://kenpom.com"
    @bmat_url = "http://matrixbracket.com"
    @kp_team_data = Hash.new
    @kp_column_names = Hash.new
    @bmat_team_data = Hash.new
    @bmat_column_names = Hash.new
  end
  
  #crawls the bracket matrix website and parses the html data into a 2D hash
  def bracketMatrixCrawler
    curr_row = 0
    curr_column = 0
    rank = 0
    num_columns = 0
    num_rows = 0

    directory = "#{Rails.root}/log/"

    db_columns = ["rank", "name", "conf", "avg_seed"]
    
    doc = Nokogiri::HTML(File.open("#{Rails.root}/app/views/test/bracketmatrix.html.erb"))


    #num_columns = (num_columns/num_rows) + 1
    #@bmat_num_columns = num_columns 
    File.open(File.join(directory, 'debug.log'), 'w') do |f|
    end

    doc.css('table tr').each do |row|
      if curr_row > 7 and curr_row < 76
        row.css('td').each do |cell|
          
          if curr_column < db_columns.length
            
            #start a new hash at each new row
            if(curr_column == 0)
              @bmat_team_data[rank] = Hash.new
            end#end if   cumn<db columns    
            
            @bmat_team_data[rank][db_columns[curr_column]] = cell.content 
            
          end #end if curr_column < db_column
          
          curr_column+= 1
        end #end each
        
        rank += 1
      end #end if row > 8
      
        curr_row += 1
        curr_column = 0
    end
  end
  
  #crawls the kenpom website and parses the html data into a 2D hash
  def kenPomCrawler
    columns = 0;
    append = ""
    # counter
    i = 0
    next_column = 0;

    rank = 1

    # Fetch and parse HTML document
    #doc = Nokogiri::HTML(open(@url))
    doc = Nokogiri::HTML(File.open("#{Rails.root}/app/views/test/kenpom.html.erb"))

    #get the columns and column names first
    doc.css('table thead:first-child tr:nth-child(2) th').each do |link|
      if columns> 11
        prepend = "ncsos_"
      elsif columns > 8
        append = "_sched"
      end

      @kp_column_names[columns] = link.content.downcase+append
      columns += 1
    end

    # get the values in the columns
    doc.css('tbody td').each do |link|
      if next_column >= columns
        rank += 1
        next_column = 0
        i = 0
        next
      end

      #if the values are subscripts, don't use them
      if i > 5 && i % 2 == 0
        i+=1
        next
      end


      if next_column == 0
        @kp_team_data[rank] = Hash.new
      end

      @kp_team_data[rank][@kp_column_names[next_column]] = link.content

      next_column += 1
      i+=1
    end

  end
end