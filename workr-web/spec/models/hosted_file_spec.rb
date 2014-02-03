require 'spec_helper'

describe HostedFile do
  it { should have_attached_file(:upload) }
  it { should validate_attachment_presence(:upload) }
  it { should validate_attachment_content_type(:upload)
    .allowing(*HostedFile::SUPPORTED_UPLOAD_TYPES)
    .rejecting('foo/bar')
  }
end
