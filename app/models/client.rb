class Client < ApplicationRecord
  before_create :generate_access_token
  validates :name, presence: true
  validates :email, presence: true

  def refresh_access_token
    loop do
      t = SecureRandom.base64.tr('+/=', 'Qrt')
      unless Client.exists?(access_token: t)
        break self.access_token = t
      end
    end
  end

  private

  def generate_access_token
   refresh_access_token
  end
end
