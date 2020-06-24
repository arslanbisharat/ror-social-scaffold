require 'rails_helper'

RSpec.describe 'Index Page', type: :feature do
  scenario 'index page' do
    visit root_path
    expect(page).to have_content('Stay in touch')
    expect(page).to have_content('Sign in')
    expect(page).to have_content('Email')
    expect(page).to have_content('Password')
  end
end
