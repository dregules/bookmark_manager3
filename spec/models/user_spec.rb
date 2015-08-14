require 'spec_helper'
require_relative '../../app/models/user.rb'

describe User do

  it 'authenticates the user when given valid email and password' do
    user = create(:user)
    authenticated_user = User.authenticate(user.email, user.password)
    expect(authenticated_user).to eq user
  end

  it 'does not authenticate when given the wrong password' do
    user = build(:user, password: 'wrong')
    expect(User.authenticate(user.email, user.password)).to eq nil
  end
end