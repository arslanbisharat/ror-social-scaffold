require 'rails_helper'
# rubocop: disable Metrics/BlockLength
RSpec.feature 'Logged in user can send/receive/acept/decline friendship invitations/requests:' do
  background do
    User.create(name: 'user_one', email: 'user_one@email.com', password: '123456')
    User.create(name: 'user_two', email: 'user_two@email.com', password: '123456')
  end
  scenario 'User is able to send friendship invitations from All Users page' do
    sign_in_with 'user_one@email.com', '123456'
    click_on 'All users'
    click_on 'Add Friend'
    expect(page).to have_content('Your friend request has been sent')
    expect(page).to_not have_content('Add friend')
  end

  scenario 'User is able to see his friend requests pending response' do
    User.first.invitations.create(friend_id: User.find_by(email: 'user_two@email.com').id, status: 'requested')
    sign_in_with 'user_two@email.com', '123456'
    click_on 'Logged as: UserTwo'
    expect(page).to have_content('Pending Requests:')
    expect(page).to have_content('user_one')
    expect(page).to have_content('Accept')
    expect(page).to have_content('Decline')
  end

  scenario 'User is able to accept his friend requests pending response' do
    User.first.invitations.create(friend_id: User.find_by(email: 'user_two@email.com').id, status: 'requested')
    sign_in_with 'user_two@email.com', '123456'
    click_on 'Logged as: UserTwo'
    click_on 'Accept'
    expect(page).to have_content('You responded to this invitation')
    expect(page).to_not have_content('Accept')
    expect(page).to_not have_content('Decline')
  end

  scenario 'User is able to decline his friend requests pending response' do
    User.first.invitations.create(friend_id: User.find_by(email: 'user_two@email.com').id, status: 'requested')
    sign_in_with 'user_two@email.com', '123456'
    click_on 'Logged as: UserTwo'
    click_on 'Decline'
    expect(page).to have_content('You responded to this invitation')
    expect(page).to_not have_content('Accept')
    expect(page).to_not have_content('Decline')
  end

  def sign_in_with(email, password)
    visit new_user_session_path
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    click_button 'Log in'
  end
end
# rubocop: enable Metrics/BlockLength
