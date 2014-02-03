class Collection < ActiveRecord::Base
  has_and_belongs_to_many :articles
  belongs_to :user
  validates :name, :user_id, presence: true

  def display_name
    name
  end
end
