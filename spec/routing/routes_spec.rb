require 'rails_helper'

RSpec.describe 'Routes', type: :routing do
  describe 'Root route' do
    it 'routes to pages#home' do
      expect(get: '/').to route_to(controller: 'pages', action: 'home')
    end
  end

  describe 'Pages routes' do
    it 'routes GET /pages/home to pages#home' do
      expect(get: '/pages/home').to route_to('pages#home')
    end
  end

  describe 'Users routes' do
    it 'routes GET /users to users#index' do
      expect(get: '/pages/home').to route_to(controller: 'pages', action: 'home')
    end

    it 'routes GET /users/:id/ban to users#ban' do
      expect(get: '/users/1/ban').to route_to(controller: 'users', action: 'ban', id: '1')
    end

    it 'routes PUT /users/:id/reactivate to users/registrations#reactive' do
      expect(put: '/users/1/reactivate').to route_to(controller: 'users/registrations', action: 'reactivate', id: '1')
    end
  end

  describe 'Admin routes' do
    it 'routes to admin#index' do
      expect(get: '/admin').to route_to(controller: 'admin', action: 'index')
    end

    it 'routes to admin#create' do
      expect(post:'/admin').to route_to(controller: 'admin', action: 'create')
    end

    it 'routes to admin#update' do
      expect(put: '/admin/1').to route_to(controller: 'admin', action: 'update', id: '1')
    end
  end

  describe 'Sign Out route' do
    it 'routes DELETE /sign_out to sessions#destroy' do
      expect(delete: '/sign_out').to route_to(controller: 'sessions', action: 'destroy')
    end
  end

  describe 'Generate Password routes' do
    it 'routes POST /generate_password to users#generate_password' do
      expect(post: '/generate_password').to route_to(controller: 'users', action: 'generate_password')
    end
  end

  describe 'Devise routes' do
    it 'routes google_oauth2 callbacks for sign in' do
      expect(get: '/auth/google_oauth2/callback').to route_to(controller: 'users/omniauth_callbacks', action: 'create')
    end

    it 'routes github callbacks for sign in' do
      expect(get: '/auth/github/callback').to route_to(controller: 'users/omniauth_callbacks', action: 'create', provider: 'github')
    end
  end

  describe 'Resque route' do
    it 'routes for resque server' do
      expect(get: '/resque').to route_to(controller: 'resque/server')
    end
  end
end
