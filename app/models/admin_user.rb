class AdminUser < ApplicationRecord
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  before_create :generate_access_token

  def refresh_access_token
    loop do
      t = SecureRandom.base64.tr('+/=', 'Qrt')
      unless AdminUser.exists?(access_token: t)
        break self.access_token = t
      end
    end
  end

  private

  def generate_access_token
   refresh_access_token
  end
end
