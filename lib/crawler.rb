##
# @author Matt Scaperoth
# @email scaperoth@gmail.com
# @description This class crawls sites and parses the html data

require 'nokogiri'
require 'open-uri'
require 'fileutils'

class Crawler
    attr_accessor :kp_url, :kp_team_data, :kp_column_names, :bmat_url, :bmat_team_data, :bmat_column_names, :bmat_num_columns
    def initialize
        @kp_url = 'http://kenpom.com'
        @bmat_url = 'http://bracketmatrix.com/'
        @kp_team_data = {}
        @kp_column_names = {}
        @bmat_team_data = {}
        @bmat_column_names = {}
    end

    def get_year_url(year, which_url = 'kenpom')
        current_year = Time.now.year.to_s

        kenpom_url = @kp_url + "/index.php?y=#{year}"
        bracket_matrix_url = @bmat_url + "/matrix_#{year}.html"

        if current_year == year
            kenpom_url = @kp_url
            bracket_matrix_url = @bmat_url
        end

        if which_url.eql? 'kenpom'
            return kenpom_url
        else
            return bracket_matrix_url
        end
      end

    # crawls the bracket matrix website and parses the html data into a 2D hash
    def bracketMatrixCrawler(year = nil, tournament = nil)
        year = Time.now.year if year.nil?

        url = get_year_url(year, 'bracket matrix')
        curr_row = 0
        curr_column = 0
        rank = 0
        num_columns = 0
        num_rows = 0

        directory = "#{Rails.root}/log/"

        db_columns = %w(rank name conf avg_seed)

        doc = Nokogiri::HTML(open(url))
        # doc = Nokogiri::HTML(File.open("#{Rails.root}/db/data/2016/bracketmatrix2016.html.erb"))
        # archive the files
        save_doc doc, year, 'bmat'

        # grab the date that is the closest to the tournament start date
        # closest_date_file = get_closest_tournament_date tournament, "#{Rails.root}/public/archive/#{year}/bmat"
        # doc = Nokogiri::HTML(File.open(closest_date_file))

        # num_columns = (num_columns/num_rows) + 1
        # @bmat_num_columns = num_columns
        File.open(File.join(directory, 'debug.log'), 'w') do |_f|
        end

        skip_rows = 7

        # only skip two rows if the first row says it's still processing
        unless doc.css('table tr')[0].to_s.include? 'OFFICIAL RESULTS'
            skip_rows = 2
        end

        doc.css('table tr').each do |row|
            if curr_row > skip_rows && curr_row < 75
                row.css('td').each do |cell|
                    if curr_column < db_columns.length

                        # start a new hash at each new row
                        if curr_column == 0
                            @bmat_team_data[rank] = {}
                        end # end if   cumn<db columns

                        @bmat_team_data[rank][db_columns[curr_column]] = cell.content

                    end # end if curr_column < db_column

                    curr_column += 1
                end # end each

                rank += 1
            end # end if row > 8

            curr_row += 1
            curr_column = 0
        end
    end

    # crawls the kenpom website and parses the html data into a 2D hash
    def kenPomCrawler(year = nil, tournament = nil)
        year = Time.now.year if year.nil?

        url = get_year_url(year, 'kenpom')
        columns = 0
        append = ''
        # counter
        i = 0
        next_column = 0

        rank = 1

        # Fetch and parse HTML document
        # doc = Nokogiri::HTML(open(@url))
        doc = Nokogiri::HTML(open(url))
        # doc = Nokogiri::HTML(File.open("#{Rails.root}/db/data/2016/kenpom2016.html.erb"))

        # archive the files
        save_doc doc, year, 'kp'

        # grab the date that is the closest to the tournament start date
        closest_date_file = get_closest_tournament_date tournament, "#{Rails.root}/public/archive/#{year}/kp"
        doc = Nokogiri::HTML(File.open(closest_date_file))

        # get the columns and column names first
        doc.css('table thead:first-child tr:nth-child(2) th').each do |link|
            if columns > 11
                append = '_ncsos'
            elsif columns > 8
                append = '_sched'
            end

            @kp_column_names[columns] = link.content.downcase.strip + append
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

            # if the values are subscripts, don't use them
            if i > 5 && i.even?
                i += 1
                next
            end

            @kp_team_data[rank] = {} if next_column == 0

            @kp_team_data[rank][@kp_column_names[next_column]] = link.content.strip

            next_column += 1
            i += 1
        end
    end

    def save_doc(doc, year, name)
        filename = File.join(Rails.root, 'public', 'archive', year, name, Time.now.strftime('%Y%m%d'))
        dir = File.dirname(filename)
        FileUtils.mkdir_p(dir) unless File.directory?(dir)
        File.open(filename, 'w+') do |f|
            f.puts(doc.inner_html)
        end
    rescue => ex
        Rails.logger.error ex.message
    end

    def get_closest_tournament_date(tournament, filepath)
        tournament_date = tournament.date.to_time
        closest_date = Time.now
        smallest_comparison = (tournament_date - closest_date).to_i.abs

        Dir.foreach(filepath) do |item|
            next if (item == '.') || (item == '..')

            file_date = item.to_time
            comparison = (tournament_date - file_date).to_i.abs
            #
            # puts tournament_date.inspect
            # puts file_date.inspect
            # puts comparison.inspect
            # puts '-----------------'

            if comparison < smallest_comparison
                closest_date = file_date
                smallest_comparison = comparison
            end
        end
        # puts closest_date.strftime('%Y%m%d')

        # return path to proper file to open
        filepath + "/#{closest_date.strftime('%Y%m%d')}"
    end
end
