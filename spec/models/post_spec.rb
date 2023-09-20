require 'rails_helper'

RSpec.describe Post, type: :model do
  current_user = User.first_or_create!(email: 'user@user.com', password: 'user12', password_confirmation: 'user12')
  it 'has a title' do
    post = Post.new(title: '', body: 'This is body', user: current_user)
    expect(post).to_not be_valid

    post.title = 'has title'
    expect(post).to be_valid
  end

  it 'has a body' do
    post = Post.new(title: 'has a title', body: '', user: current_user)
    expect(post).to_not be_valid

    post.body = 'a valid body'
    expect(post).to be_valid
  end

  it 'has a title at least 2 characters long' do
    post = Post.new(title:'', body: 'this is the body', user: current_user)
    expect(post).to_not be_valid

    post.title = 'ab'
    expect(post).to be_valid
  end

  it 'has a body between 10 to 100 characters' do
    post = Post.new(title:'has a valid title', body: '', user: current_user)
    expect(post).to_not be_valid

    post.body = 'this is body'
    expect(post).to be_valid

    hundred_char_string = 'gK7qwxPruuSvyCnHCYbqfTkqpoGIwVSOF3PmEmxtfCzGonLB5jtuuUDM9lPIAh6qjJapcQDpaFiL3S3bSV4KBjRiW2GkspkM29Mv'
    post.body = hundred_char_string
    expect(post).to be_valid
  end
end
