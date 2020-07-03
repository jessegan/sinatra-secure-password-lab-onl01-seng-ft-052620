class User < ActiveRecord::Base
    has_secure_password
    validates :balance,:numericality => {:greater_than_or_equal_to => 0}
end
