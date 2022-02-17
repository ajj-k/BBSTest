ActiveRecord::Base.establish_connection

class BBSData < ActiveRecord::Base
    belongs_to :users
end

class User < ActiveRecord::Base
    has_secure_password
    has_many :bbsdatas
end