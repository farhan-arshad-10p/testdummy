class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, 
         :validatable, :omniauthable, omniauth_providers: [:twitter]

  has_many :collections
  has_many :articles
  has_many :viewed_articles
  has_many :flags

  has_many :follower_relationships, class_name: 'Relationship', foreign_key: "follower_id", dependent: :destroy
  has_many :followed_relationships, class_name: 'Relationship', foreign_key: "followed_id", dependent: :destroy
  has_many :following, through: :follower_relationships, source: :followed
  has_many :followers, through: :followed_relationships, source: :follower

  has_and_belongs_to_many :interests

  validates_acceptance_of :terms_of_service, accept: true
  validates :first_name, :last_name, presence: true
  validates :interests, length: { minimum: 1 }

  searchable do
    text :first_name
    text :last_name
    text :email
  end

  SUPPORTED_AVATAR_TYPES = [
    'image/jpg',
    'image/jpeg',
    'image/gif',
    'image/png',
    'image/x-png',
    'image/pjpeg'
  ]

  has_attached_file :avatar, PAPERCLIP_STORAGE_OPTIONS.merge(default_url: "/assets/missing_avatar.png")
  validates_attachment :avatar, content_type: { content_type: SUPPORTED_AVATAR_TYPES }

  def display_name
    email
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
