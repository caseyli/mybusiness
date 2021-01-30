class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model  
  has_many :blog_posts
  has_one :profile, dependent: :destroy
  has_many :time_off_entries

  scope :alphabetical, -> { order("email asc") }

  accepts_nested_attributes_for :profile, update_only: true
end
