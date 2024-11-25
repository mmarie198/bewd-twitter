class User < ApplicationRecord
    has_many :sessions, dependent: :destroy
    has_many :tweets, dependent: :destroy
  
    validates :username, 
              presence: true, 
              uniqueness: true, 
              length: { minimum: 3, maximum: 64 }
    
    validates :password, 
              presence: true, 
              length: { minimum: 8, maximum: 64 }
    
    validates :email, 
              presence: true, 
              length: { minimum: 5, maximum: 500 },
              uniqueness: true
  
    # Use has_secure_password for password hashing
    has_secure_password
end
