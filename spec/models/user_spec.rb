require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user1) do
    User.create(id: 1, name: 'example_user', email: 'user@email.com',
                password: '123456', gravatar_url: nil)
  end

  let(:user2) do
    User.create(id: 2, name: 'example_user_2', email: 'user_2@email.com',
                password: '123456', gravatar_url: nil)
  end

  let(:user3) do
    User.new(name: 'example_user_3', email: 'user_3@email.com',
             password: '123456', gravatar_url: nil)
  end

  # rubocop:disable Lint/AmbiguousBlockAssociation
  it 'should be able to create friend invitations' do
    expect { user1.invite user2.id }.to change { user1.invitations.count }.by(1)
  end

  it 'should not be able to invite a user if there is an invitation pending response already' do
    user1.invite user2.id
    expect { user1.invite user2.id }.to_not change { user1.invitations.count }
  end

  it 'should be able to receive friend requests' do
    expect { user1.invite user2.id }.to change { user2.requests.count }.by(1)
  end

  it 'should not be able to increase friend requests if there is one pending response already' do
    user1.invite user2.id
    expect { user1.invite user2.id }.to_not change { user2.requests.count }
  end

  it 'should not increase count of friends when invitation is declined' do
    user1.invite user2.id
    expect { user2.decline_request_from user1.id }.to_not change { user1.friends.count }

    expect(user1.friends_with?(user2.id)).to be false
  end

  it 'should increase count of friends when invitation is accepted' do
    user1.invite user2.id
    expect { user2.accept_request_from user1.id }.to change { user1.friends.count }.by(1)

    expect(user1.friends_with?(user2.id)).to be true
  end

  it 'should reflect friendship for both sides' do
    user1.invite user2.id
    user2.accept_request_from user1.id
    expect(user1.friends_with?(user2.id)).to be true
    expect(user2.friends_with?(user1.id)).to be true
  end

  it 'it should be able to unfriend a user who was a friend' do
    user1.invite user2.id
    user2.accept_request_from user1.id
    expect { user2.unfriend user1.id }.to change { user2.friends.count }
  end

  it 'is not valid if there are the same email saved' do
    user = User.new(name: 'Other', email: 'user@email.com')
    expect(user).to_not be_valid
  end

  it 'is not valid without an name' do
    user3.name = ''
    expect(user3).to_not be_valid
  end

  it 'is not valid with name biger than 20 characters' do
    user3.name = 'a' * 21
    expect(user3).to_not be_valid
  end

  describe 'Associations' do
    it { should have_many :friends }
    it { should have_many :invitations }
    it { should have_many :requests }
  end
end

# rubocop:enable Lint/AmbiguousBlockAssociation
