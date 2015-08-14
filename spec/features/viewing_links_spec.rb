require './app/app.rb'
require './app/models/link.rb'
require './app/models/tag.rb'
require 'byebug'

feature 'Viewing links' do
  before(:each) do
    Link.create(url: 'http://www.makersacademy.com', title: 'Makers Academy', tags: [Tag.first_or_create(name: 'education')])
    Link.create(url: 'http://www.google.com', title: 'Google', tags: [Tag.first_or_create(name: 'search')])
    Link.create(url: 'http://www.zombo.com', title: 'This is Zombocom', tags: [Tag.first_or_create(name: 'bubbles')])
    Link.create(url: 'http://www.bubble-bobble.com', title: 'Bobble Bobble', tags: [Tag.first_or_create(name: 'bubbles')])
  end

  scenario 'I can see existing links on the links page' do
    Link.create(url: 'http://www.makersacademy.com', title: 'Makers Academy')

    visit '/links'

    # as this is our first feature test,
    # the following expectation is a quick check that everything is working.
    expect(page.status_code).to eq 200
    # you might remove this later.
    # why do we use within here?
    # might we get a false positive if we just test for 'Makers Academy'?
    within 'ul#links' do
      expect(page).to have_content('Makers Academy')
    end
  end
  scenario 'I can filter links by tag' do
    visit '/tags/bubbles'
    within 'ul#links' do
      expect(page).not_to have_content('Makers Academy')
      expect(page).not_to have_content('Code.org')
      expect(page).to have_content('This is Zombocom')
      expect(page).to have_content('Bobble Bobble')
    end
  end
end
