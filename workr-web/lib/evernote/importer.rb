module Evernote
  class Importer
    def self.import(data, collection_id, logger, bar=nil)
      collection = Collection.find_by(id: collection_id)
      rows = Clipper::Parser.parse_evernote(data, collection.name, logger)
      bar ||= ProgressBar.new(0)
      bar.max += rows.size
      rows.each do |row|
        begin
          content_source = Clipper::Importer.import_content_source(url: row[:url])
          article = Clipper::Importer.create_from_content_source_in_collection(content_source, collection, {tag_list: row[:tags]}, '...')
        rescue
          logger.info("Could not import url: [#{row[:url]}]")
        end
        bar.increment!
      end
    end

    def self.import_directory(directory_path, user_id, logger)
      log_path = Rails.root.join('log', 'evernote_import.log')

      file = File.open(log_path, File::WRONLY | File::APPEND | File::CREAT)
        file.truncate(0)
        logger = Logger.new(file)

        user = User.find(user_id)
        Dir.chdir(directory_path)
        evernote_files = Dir.glob("*.enex")

        book_bar = ProgressBar.new(evernote_files.size)
        evernote_files.each do |filename|
          collection_name = File.basename(filename, ".enex").titleize
          puts "creating collection: #{collection_name}"
          collection = user.collections.find_or_create_by(name: collection_name, user_id: user.id)
          import_file = File.join(Dir.pwd, filename)
          Importer.import(File.open(import_file), collection.id, logger, book_bar)
          book_bar.increment!
        end
      file.close

      puts "Completed import..."
      puts `cat #{log_path}`
    end

    def self.import_missing_from_directory(directory_path, logger)
      log_path = Rails.root.join('log', 'evernote_import.log')

      file = File.open(log_path, File::WRONLY | File::APPEND | File::CREAT)
        file.truncate(0)
        logger = Logger.new(file)

        Dir.chdir(directory_path)
        evernote_files = Dir.glob("*.enex")

        book_bar = ProgressBar.new(evernote_files.size)
        evernote_files.each do |filename|
          collection_name = File.basename(filename, ".enex").titleize
          collection = Collection.find_by(name: collection_name)
          if collection
            import_file = File.join(Dir.pwd, filename)
            rows = Clipper::Parser.parse_evernote(File.open(import_file), collection_name, logger)
            bar ||= ProgressBar.new(0)
            bar.max += rows.size
            rows.each do |row|
              content_source = ContentSource.find_by(url: row[:url])
              if content_source
                if !collection.articles.map(&:content_source).flatten.map(&:id).index(collection.id)
                  article = Clipper::Importer.create_from_content_source_in_collection(content_source, collection, {tag_list: row[:tags]}, '...')
                end
              end
              book_bar.increment!
            end
          end
          book_bar.increment!
        end
      file.close
    end
  end
end
