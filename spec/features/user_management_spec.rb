#require './app/models/user.rb'
require 'spec_helper'

feature 'User sign up' do
  # the tests that check the UI
  # (have_content, etc.) should be separate from the tests
  # that check what we have in the DB since these are separate concerns
  # and we should only test one concern at a time.
  # However, we are currently driving everything through
  # feature tests and we want to keep this example simple.

  scenario 'I can sign up as new user' do
    user = create :user
    expect { sign_up(user) }.to change(User, :count).by(1)
    expect(page).to have_content("Welcome, #{user.email}")
    expect(User.first.email).to eq user.email
  end

  scenario 'with a password that does not match' do
    # again it's questionable whether we should be testing the model at this
    # level.  We are mixing integration tests with feature tests.
    # However, it's convenient for our purposes.
    user = create(:user, password_confirmation: 'wrong')
    expect { sign_up(user) }.not_to change(User, :count)
    expect(current_path).to eq '/users'
    expect(page).to have_content 'Password and confirmation password do not match'
  end


  scenario 'without an email' do
    user_no_email = create(:user, email: "")
    expect { sign_up(user_no_email) }.to_not change(User, :count)
    expect(current_path).to eq '/users/new'
  end
end

def sign_up(user) # <--helper method!
  visit '/users/new'
  fill_in :email, with: user.email
  fill_in :password, with: user.password
  fill_in :password_confirmation, with: user.password_confirmation
  click_button 'Sign up'
end
