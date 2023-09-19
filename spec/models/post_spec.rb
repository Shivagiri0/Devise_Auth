require 'rails_helper'

RSpec.describe Post, type: :model do
  it 'is valid with valid attributes' do
    user = User.create(email: 'user@user.com')
    post = Post.new(title: 'Test Post', body: 'This is a test post.', user: user)
    expect(post).to be_valid
  end

  it 'is not valid without a title' do
    post = Post.new(body: 'This is a test post.')
    expect(post).to_not be_valid
  end

  it 'is not valid without body' do
    post = Post.new(title: 'Test Post')
    expect(post).to_not be_valid
  end

  it 'belongs to a user' do
    user = User.create(email: 'user@user.com')
    post = Post.new(title: 'Test Post', body: 'This is a test post.', user: user)
    expect(post.user).to eq(user)
  end
end
