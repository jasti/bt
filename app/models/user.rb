# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  has_secure_password
  has_many :posts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy

  #^^ source attribute is defined below so rails can deduce the underlying attribute in the relationshiop table
  # By default, rails would singularize whatever is defined and look for singulized_id.Look at has_many:followers

  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                     class_name:  "Relationship",
                                     dependent:   :destroy
  #^^ the source attribute is not really needed below since rails would singulize followers to follower and link to foller_id
  #^^ Leaving it here for consistency like above in has_many:followed_users
  has_many :followers, through: :reverse_relationships, source: :follower


  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  def feed
     Post.from_users_followed_by(self)
   end


   def following?(other_user)
       relationships.find_by_followed_id(other_user.id)
     end

   def follow!(other_user)
       relationships.create!(followed_id: other_user.id)
   end

   def unfollow!(other_user)
       relationships.find_by_followed_id(other_user.id).destroy
   end


  private

      def create_remember_token
        self.remember_token = SecureRandom.urlsafe_base64
      end
end