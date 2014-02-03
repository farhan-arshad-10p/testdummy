class AddUploadToUploadedFiles < ActiveRecord::Migration
  def change
    add_attachment :uploaded_files, :upload
  end
end
