class Work < ApplicationRecord
  include ImageUploader::Attachment(:image)
  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true, length: { maximum: 65_535 }
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

  belongs_to :user
  def self.ransackable_attributes(auth_object = nil)
    [ "body", "created_at", "id", "image_data", "title", "updated_at", "user_id" ]
  end
  def self.ransackable_associations(auth_object = nil)
    [ "bookmarks", "comments", "user" ]
  end
end
