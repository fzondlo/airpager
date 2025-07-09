class MessageViewModel < ApplicationViewModel
  def from_guest?
    return true unless model.sender_role.present?

    model.sender_role == 'guest'
  end

  def from_reservation?
    model.reservation_id.present?
  end

  def from_inquiry?
    !from_reservation?
  end
end
