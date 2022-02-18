require 'bundler/setup'
Bundler.require

ActiveRecord::Base.establish_connection

class User < ActiveRecord::Base
    has_secure_password
    has_many :bbsdatas
end

class BBSData < ActiveRecord::Base
    belongs_to :users
end
