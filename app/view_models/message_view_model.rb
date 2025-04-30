class MessageViewModel < ApplicationViewModel
  def from_guest?
    return true unless model.sender_role.present?

    model.sender_role == 'guest'
  end
end
