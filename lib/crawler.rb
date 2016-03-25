require 'nokogiri'
require 'open-uri'

class Crawler
  attr_accessor :url, :kp_team_data, :kp_column_names, :bmat_team_data, :bmat_column_names, :bmat_num_columns
  def initialize(url)
    @url = url
    @kp_team_data = Hash.new
    @kp_column_names = Hash.new
    @bmat_team_data = Hash.new
    @bmat_column_names = Hash.new
    kenPomCrawler
    bracketMatrixCrawler

  end

  def bracketMatrixCrawler
    curr_row = 0
    curr_column = 0
    index = 0
    num_columns = 0
    num_rows = 0

    directory = "#{Rails.root}/log/"



    db_columns = ["rank", "name", "conf", "avg_seed"]

    doc = Nokogiri::HTML(File.open("#{Rails.root}/app/views/test/bracketmatrix.html.erb"))

    doc.css('table tr').each do |link|
      num_rows+=1
    end

    doc.css('table tr td').each do |link|
      num_columns+=1
    end

    num_columns = num_columns/num_rows - 1
    @bmat_num_columns = num_columns
    File.open(File.join(directory, 'debug.log'), 'w') do |f|
    end

    doc.css('table tr td').each do |link|
      if link.content.nil? || link.content.empty? || link.content.blank?
        next
      end
      #check if we're on a new column
      if curr_column > num_columns
        curr_column = 0
        curr_row += 1
        index += 1
      end

      File.open(File.join(directory, 'debug.log'), 'a') do |f|
        f.puts link.content
      end
      #skip everything that's too far down
      if curr_row < 9 || curr_row > 63
        next
      end

      if curr_column > db_columns.length
        curr_column += 1
        next
      end


      if(curr_column == 0)
        @bmat_team_data[index] = Hash.new
      end

      @bmat_team_data[index][db_columns[curr_column]] = link.content

      curr_column += 1

    end
  end

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
