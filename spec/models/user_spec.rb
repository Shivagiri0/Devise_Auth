require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    let(:user) { build :user }

    it 'validates user' do
      user.valid? == true
    end

    it 'validates password not common' do
      user = User.new(email: 'user@user.com', password: '123456')
      expect(user).to_not be_valid
      expect(user.errors[:password]).to include('Please choose a stronger password.')
    end

    it 'is not valid without email' do
      user = User.new(email: 'admin@admin.com')
      expect(user).to_not be_valid
    end
  end
end
