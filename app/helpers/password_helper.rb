module PasswordHelper
  def generate_random_password
    SecureRandom.base64(12)
  end
end