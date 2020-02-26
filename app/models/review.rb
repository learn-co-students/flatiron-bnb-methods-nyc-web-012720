class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  #validations
  validates :rating, :description, :reservation_id, presence: true
  validate :accepted_and_checkout_happened

  private

  def accepted_and_checkout_happened
    if reservation && reservation.checkout > Date.today || reservation.try(:status) != "accepted"
      errors.add(:reservation_id, "Not a valid review because status or checkout date hasnt happened")
    end
  end
end
