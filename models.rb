ActiveRecord::Base.establish_connection

class BBSdata < ActiveRecord::Base
end

class USer < ActiveRecord::Base
    has_secure_password
end