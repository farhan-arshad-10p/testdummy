class HostedFile < ActiveRecord::Base
  SUPPORTED_UPLOAD_TYPES = [
    'image/jpg',
    'image/jpeg',
    'image/gif',
    'image/png',
    'image/x-png',
    'image/pjpeg',
    'text/plain',
    'text/rtf',
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'application/vnd.ms-excel',
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    'application/vnd.ms-powerpoint',
    'application/vnd.openxmlformats-officedocument.presentationml.presentation',
    'application/pdf',
    'application/x-pdf',
    'application/acrobat',
    'applications/vnd.pdf',
    'text/pdf',
    'text/x-pdf',
  ]

  has_attached_file :upload, PAPERCLIP_STORAGE_OPTIONS
  validates_attachment :upload, presence: true, content_type: { content_type: SUPPORTED_UPLOAD_TYPES }
end
