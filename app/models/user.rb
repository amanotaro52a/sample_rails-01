class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :works, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_works, through: :bookmarks, source: :work

  def own?(object)
    id == object&.user_id
  end

  def bookmark(work)
    bookmark_works << work
  end

  def unbookmark(work)
    bookmark_works.destroy(work)
  end

  def bookmark?(work)
    bookmark_works.include?(work)
  end
end
