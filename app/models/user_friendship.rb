class UserFriendship < ApplicationRecord
  validates :user_id, presence: true
  validates :friend_id, presence: true
  validates :status, presence: true, acceptance: { accept: %w[requested confirmed declined cancelled] }

  belongs_to :requestor, class_name: 'User', foreign_key: 'user_id'
  belongs_to :friend, class_name: 'User'

  scope :with_status, ->(status) { where 'status = ?', status }
  scope :to_user, ->(user_id) { where 'friend_id = ?', user_id }
  scope :from_user, ->(user_id) { where 'user_id = ?', user_id }

  def self.update_invite(u_id, f_id, status)
    if where(user_id: u_id, friend_id: f_id).exists?
      where(user_id: u_id, friend_id: f_id).update(status: status)
    else
      create(user_id: u_id, friend_id: f_id, status: status)
    end
  end

  def self.update_friendship(u_id, f_id, status)
    if where(user_id: u_id, friend_id: f_id).exists?
      where(user_id: u_id, friend_id: f_id).update(status: status)
    else
      create(user_id: u_id, friend_id: f_id, status: status)
    end
    if where(user_id: f_id, friend_id: u_id).exists?
      where(user_id: f_id, friend_id: u_id).update(status: status)
    else
      create(user_id: f_id, friend_id: u_id, status: status)
    end
  end
end
