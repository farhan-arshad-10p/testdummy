class ContentSource < ActiveRecord::Base
  has_many :articles

  validates :url, presence: true, uniqueness: true

  def display_name
    url
  end
end
