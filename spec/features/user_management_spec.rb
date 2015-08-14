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
    user = build :user
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
    expect(page).to have_content 'Password does not match the confirmation'
  end

  scenario 'without an email' do
    user_no_email = create(:user, email: "")
    expect { sign_up(user_no_email) }.to_not change(User, :count)
    expect(current_path).to eq '/users/new'
  end

  scenario 'I cannot sign up with an existing email' do
    user = create :user
    sign_up(user)
    expect { sign_up(user) }.to change(User, :count).by(0)
    expect(page).to have_content('Email is already taken')
  end
end

feature 'User sign in' do

  scenario 'with correct credentials' do
   user = create(:user)
   sign_up(user)
   sign_in(user)
   expect(page).to have_content("Welcome, #{user.email}")
  end
end

feature 'User signs out' do
  scenario 'while being signed in' do
    user = create(:user)
    sign_in(user)
    click_button 'Sign out'
    expect(page).to have_content('goodbye!')
    expect(page).not_to have_content("Welcome, #{user.email}")
  end
end

