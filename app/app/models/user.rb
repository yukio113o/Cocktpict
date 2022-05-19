class User < ApplicationRecord
  
  has_many :posts, dependent: :destroy
  has_many :likes
  has_many :comments
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followings, through: :relationships, source: :followed
  has_many :followers, through: :reverse_of_relationships, source: :follower
  
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  validates :name, presence: true, length: {maximum: 50}
  
  mount_uploader :profile_photo, ProfilePhotoUploader
  
  def update_without_current_password(params, *options)
    
    if params[:paassword].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end
    
    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end
  
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end
  
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end
  
  def following?(user)
    followings.include?(user)
  end
  
  def posts
    return Post.where(user_id: self.id).order('created_at DESC')
  end
  
end
