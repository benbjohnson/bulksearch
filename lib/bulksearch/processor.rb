class BulkSearch
  # The processor fills in empty spreadsheet cells with results from Bing
  # and/or Yahoo BOSS searches.
  class Processor
    ############################################################################
    #
    # Constructor
    #
    ############################################################################
    
    def initialize(options={})
      self.providers = options[:providers] || []
    end


    ############################################################################
    #
    # Attributes
    #
    ############################################################################
    
    # A list of search providers to use with the processor (:bing, :boss).
    attr_accessor :providers
    

    ############################################################################
    #
    # Methods
    #
    ############################################################################
    
    # Processes the file using the appropriate search services.
    #
    # @param [String] file  The path to the spreadsheet to open.
    def process(file)
      file = File.expand_path(file)
      
      # Setup clients.
      bing_client = Binged::Client.new()
      
      # Open the spreadsheet.
      book = Spreadsheet.open(file)
      sheet = book.worksheet(0)
      
      # Read the headers.
      headers = sheet.row(0).map { |cell| cell.to_s }

      begin
        # Loop over the remaining rows and 
        sheet.each(1) do |row|
          # Determine base options.
          options = {}
          headers.each_with_index do |header, index|
            case header
            when 'TERMS' then options[:terms] = row[index].to_s
            when 'SITE' then options[:site] = row[index].to_s
            end
          end
        
          # Perform searches on the rest of the columns.
          headers.each_with_index do |header, index|
            next unless header.index(/^[A-Z]+$/).nil?
          
            # Combine search terms.
            terms = "#{options[:terms].to_s} #{header}"
          
            # Only update the field if it's blank.
            if row[index].to_s =~ /^\s*$/
              # Process using Bing.
              if providers.index(:bing)
                puts "? #{terms} (#{options[:site]})"
                search = bing_client.web.containing(terms)
                search.from_site(options[:site]) unless options[:site].nil?
                result = search.fetch.results[0..2].select {|result| URI.parse(result.url).path != '/' rescue false}.first

                if !result.nil?
                  puts "#{result.url}\n\n"
                  row[index] = result.url
                else
                  puts ""
                end
              end

              # Process using Yahoo BOSS.
              if providers.index(:boss)
                puts "BOSS: #{terms}"
                BOSSMan::Search.web(terms, :count => 1)
                search = boss_client.web.containing(terms)
                result = search.results.first

                if !result.nil?
                  puts "#{result.url}\n\n"
                  row[index] = result.url
                else
                  puts ""
                end
              end
            end
          end
        end
      
      # If an error occurs, save off the file before exiting.
      ensure
        # Backup original file & write over original file.
        FileUtils.mv(file, "#{File.dirname(file)}/.#{File.basename(file)}")
        book.write(file)
      end
    end
  end
end