class Import < Thor
  require File.join(File.dirname(__FILE__), *%w[.. config environment])
  require File.join(File.dirname(__FILE__), 'thor_helpers')
  include ThorHelpers

  desc "evernote DATA_FILE COLLECTION_ID", "Imports an evernote enex file"
  def evernote(file_name, collection_id)
    logger = Logger.new(STDOUT) 
    file = File.open(file_name)
    Evernote::Importer.import(file, collection_id, logger)
  end

  desc "evernote_directory DIRECTORY_PATH USER_ID", "Imports a directory of evernote enex files"
  def evernote_directory(dir, user_id)
    logger = Logger.new(STDOUT) 
    Evernote::Importer.import_directory(dir, user_id, logger)
  end

  desc "evernote_missing_directory DIRECTORY_PATH", "Imports a directory of evernote enex files and creates articles for missing ones"
  def evernote_missing_directory(dir)
    logger = Logger.new(STDOUT) 
    Evernote::Importer.import_missing_from_directory(dir, logger)
  end
end
