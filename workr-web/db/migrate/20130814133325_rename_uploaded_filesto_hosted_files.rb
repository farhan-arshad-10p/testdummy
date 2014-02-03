class RenameUploadedFilestoHostedFiles < ActiveRecord::Migration
  def change
    rename_table :uploaded_files, :hosted_files
  end
end
