require 'rails_helper'

RSpec.feature 'Guest signs up' do
  scenario 'Guest visits Sign Up page' do
    visit new_user_registration_path
    expect(page).to have_content('Sign up')
  end
  scenario 'with valid information' do
    sign_up_with 'user', 'user@email.com', '123456', '123456'
    expect(page).to have_content('Sign out')
    expect(page).to have_content('Welcome! You have signed up successfully.')
  end

  scenario 'with missing information' do
    sign_up_with '', '', '', ''
    expect(page).to have_content('Sign up')
    expect(page).to have_content("Email can't be blank")
    expect(page).to have_content("Password can't be blank")
    expect(page).to have_content("Name can't be blank")
  end

  scenario 'with invalid information' do
    sign_up_with 'a' * 30, 'email@', '123', '123'
    expect(page).to have_content('Sign up')
    expect(page).to have_content('Name is too long')
    expect(page).to have_content('Name is too long')
    expect(page).to have_content('Email is invalid')
    expect(page).to have_content('Password is too short')
  end
end

def sign_up_with(name, email, password, password_conf)
  visit new_user_registration_path
  fill_in 'Name', with: name
  fill_in 'Email', with: email
  fill_in 'Password', with: password
  fill_in 'Password confirmation', with: password_conf
  click_button 'Sign up'
end
