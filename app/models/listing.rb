class Listing < ActiveRecord::Base
  #associations
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  ##validations
  validates :address, :listing_type, :title, :description, :price, :neighborhood_id, presence: true

  #callbacks
  before_create :set_host
  before_destroy :unset_host

  def average_review_rating
    reviews.average(:rating)
  end

  private

  def set_host
    user = User.find(self.host_id)
    user.become_host
  end

  def unset_host
    user = User.find(self.host_id)
    if user.listings.count == 1
      user.deactivate_host
    end
  end

end
