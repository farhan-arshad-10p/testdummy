class Invite < ActiveRecord::Base
  belongs_to :user

  validates_uniqueness_of :code
  validates_presence_of [:code]

  after_initialize :gernate_and_set_code

  scope :active, -> { where(active: true) }

  private
  def gernate_and_set_code
    self.code ||= SecureRandom.urlsafe_base64(4) 
  end
end
