class Session < ApplicationRecord
    belongs_to :user

    validates :user_id, presence: true
    validates :token, presence: true, uniqueness: true
  
    before_validation :generate_token, on: :create
  
    private
  
    def generate_token
      self.token = SecureRandom.urlsafe_base64(32)
    end
end
