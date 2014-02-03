class Article < ActiveRecord::Base
  has_and_belongs_to_many :collections
  belongs_to :content_source
  belongs_to :user
  has_many :viewed_articles, dependent: :destroy
  has_many :ratings, dependent: :destroy

  has_many :views, class_name: "ViewedArticle"

  acts_as_taggable

  validates :user_id, :type, :content_source, :title, :description, presence: true
  validates :collections, presence: { message: 'choose a collection'}
  validates_associated :content_source
  scope :with_defaults, -> {includes(:collections, :tags, :content_source)}

  searchable do
    text :title, more_like_this: true
    text :description, more_like_this: true
    text :content, more_like_this: true do
      content_source.content
    end
    text :tags do
      tag_list.join(', ')
    end
    text :url, more_like_this: true do
      content_source.url
    end

    double :average_rating
  end

  def display_name
    title
  end

  def clipped_name
    collections.first.user.full_name
  end
  
  def clipped_collection
    collections.first.name
  end

  def average_rating
    if ratings.present?
      ratings.map(&:rating).reduce(:+) / ratings.size.to_f
    else
      0
    end
  end
end 
