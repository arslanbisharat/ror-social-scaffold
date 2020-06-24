require 'rails_helper'

RSpec.describe UserFriendship, type: :model do
  let(:fr) do
    User.create(id: 2, name: 'example_user_2', email: 'user_2@email.com',
                password: '123456', gravatar_url: nil)
    User.create(id: 1, name: 'example_user', email: 'user@email.com',
                password: '123456', gravatar_url: nil)
    UserFriendship.new(user_id: 1, friend_id: 2, status: 'requested')
  end

  it 'is valid with all of the correct fields' do
    expect(fr).to be_valid
  end

  it 'is not valid without user_id' do
    fr.user_id = nil
    expect(fr).to_not be_valid
  end

  it 'is not valid without friend_id' do
    fr.friend_id = nil
    expect(fr).to_not be_valid
  end

  it 'is not valid if the requested friend doesnt exist' do
    fr.friend_id = 3
    expect(fr).to_not be_valid
  end

  it 'is not valid if the status is different from: requested, confirmed, declined, cancelled' do
    fr.status = 'not'
    expect(fr).to_not be_valid
  end

  it 'is valid if the status is one from: requested, confirmed, declined, cancelled' do
    fr.status = 'declined'
    expect(fr).to be_valid
  end

  describe 'Validations' do
    it { should validate_presence_of :user_id }
    it { should validate_presence_of :friend_id }
    it { should validate_presence_of :status }
    it { should allow_values('requested', 'confirmed', 'declined', 'cancelled').for :status }
  end
  describe 'Associations' do
    it { should belong_to :requestor }
    it { should belong_to :friend }
  end
end
