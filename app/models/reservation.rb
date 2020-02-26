class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  #validations
  validates :checkin, :checkout, presence: true
  validate :available, :check_out_after_check_in, :guest_and_host_not_the_same

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    duration * listing.price
  end

  private

  def available
    Reservation.where(listing_id: listing.id).where.not(id: id).each do |res|
      booked_dates = res.checkin..res.checkout
      if booked_dates === checkin || booked_dates === checkout
        errors.add(:checkout, "This listing is unavailable on those dates")
      end
    end
  end

  def check_out_after_check_in
    if checkout && checkin && checkout <= checkin
      errors.add(:checkout, "Your checkout date needs to be after your checkin date")
    end
  end

  def guest_and_host_not_the_same
    if guest_id == listing.host_id
      errors.add(:guest_id, "You host this listing dumbass!")
    end
  end
end
