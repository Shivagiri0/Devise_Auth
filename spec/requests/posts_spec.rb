require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  current_user = User.first_or_create!(email: 'user@user.com', password: 'user12', password_confirmation: 'user12')

  let(:valid_attributes) do
    {
      'id' => '1',
      'title' => 'title',
      'body' => 'this is body'
    }
  end

  let(:invalid_attributes) do
    {
      'id' => 'a',
      'title' => '1',
      'body' => '12345'
    }
  end

  describe 'GET /index' do
    it 'renders successful response' do
      post = Post.new(valid_attributes)
      post.user = current_user
      post.save
      get posts_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      post = Post.new(valid_attributes)
      post.user = current_user
      post.save
      get posts_url(post)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get posts_url
      expect(response).to be_successful
    end
  end
end
