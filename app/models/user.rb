class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :friendships, -> { where status: 'confirmed' }, class_name: 'UserFriendship', foreign_key: 'user_id'
  has_many :invitations, class_name: 'UserFriendship', foreign_key: 'user_id'
  has_many :requests, class_name: 'UserFriendship', foreign_key: 'friend_id'

  has_many :friends, through: :friendships, source: 'friend'
  has_many :invitees, through: :invitations, source: 'friend'
  has_many :requestors, through: :requests, source: 'requestor'

  scope :with_status, ->(status) { where 'user_friendships.status = ?', status }

  def invitation_status_with(user_id)
    return nil unless invitations.to_user(user_id).exists?

    invitations.to_user(user_id).first.status
  end

  def requested_status_with(user_id)
    return nil unless requests.from_user(user_id).exists?

    requests.from_user(user_id).first.status
  end

  def pending_invitations
    invitations.with_status('requested')
  end

  def pending_requests
    requests.with_status('requested')
  end

  def pending_invitation_for?(user_id)
    invitations.to_user(user_id).with_status('requested').exists?
  end

  def pending_invitation_for(user_id)
    invitations.to_user(user_id).with_status('requested').first
  end

  def pending_request_from?(user_id)
    requests.from_user(user_id).with_status('requested').exists?
  end

  def pending_request_from(user_id)
    requests.from_user(user_id).with_status('requested').first
  end

  def friends_with?(user_id)
    friendships.where('friend_id = ?', user_id).exists?
  end

  def friendship_with(user_id)
    friendships.where('friend_id = ?', user_id).first
  end

  def invite(user_id)
    if pending_request_from?(user_id) || pending_invitation_for?(user_id) || user_id == id
      puts 'Not invited because there was a pending invitation or request from that user'
    else
      UserFriendship.update_invite(id, user_id, 'requested')
    end
  end

  def cancel_invite(user_id)
    if pending_invitation_for?(user_id)
      UserFriendship.update_invite(id, user_id, 'cancelled')
    else
      puts 'No pending invitation for that user'
    end
  end

  def accept_request_from(user_id)
    if pending_request_from?(user_id)
      UserFriendship.update_friendship(user_id, id, 'confirmed')
    else
      puts 'No pending request from that user'
    end
  end

  def decline_request_from(user_id)
    if pending_request_from?(user_id)
      UserFriendship.update_invite(user_id, id, 'declined')
    else
      puts 'No pending request from that user'
    end
  end

  def unfriend(user_id)
    if friends_with?(user_id)
      UserFriendship.update_friendship(user_id, id, 'cancelled')
    else
      puts 'this user was not your friend'
    end
  end

  def timeline_posts
    friends_n_self = friends.map(&:id)
    friends_n_self << id
    Post.where('user_id IN (?)', friends_n_self).ordered_by_most_recent
  end
end
