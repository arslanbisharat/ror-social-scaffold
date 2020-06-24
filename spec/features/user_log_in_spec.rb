require 'rails_helper'

RSpec.feature 'Vistor signs in' do
  background do
    User.create(name: 'user', email: 'user@email.com', password: '123456')
  end
  scenario 'with valid email and password' do
    sign_in_with 'user@email.com', '123456'
    expect(page).to have_content('Sign out')
  end
  scenario 'with in-valid email and/or password' do
    sign_in_with 'noexist@email.com', '123'
    expect(page).to have_content('Sign in')
    expect(page).to have_content('Invalid Email or password')
  end
end

def sign_in_with(email, password)
  visit new_user_session_path
  fill_in 'Email', with: email
  fill_in 'Password', with: password
  click_button 'Log in'
end
