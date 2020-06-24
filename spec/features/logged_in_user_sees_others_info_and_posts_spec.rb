require 'rails_helper'

RSpec.feature 'Logged in user can see other users:' do
  background do
    User.create(name: 'user_one', email: 'user_one@email.com', password: '123456')
    User.create(name: 'user_two', email: 'user_two@email.com', password: '123456')
    User.create(name: 'user_three', email: 'user_three@email.com', password: '123456')
  end
  scenario 'User is able to see all users list' do
    sign_in_with 'user_one@email.com', '123456'
    click_link('All users')
    expect(page).to have_content('Name: user_one')
    expect(page).to have_content('Name: user_two')
    expect(page).to have_content('Name: user_three')
  end
  scenario 'User is able to see selected user page with their name and posts' do
    sign_in_with 'user_one@email.com', '123456'
    click_link('All users')
    click_link('See Profile', href: "/users/#{User.find_by(name: 'user_two').id}")
    expect(page).to have_content('Name: user_two')
    expect(page).to have_content('Recent posts:')
  end
end

def sign_in_with(email, password)
  visit new_user_session_path
  fill_in 'Email', with: email
  fill_in 'Password', with: password
  click_button 'Log in'
end
