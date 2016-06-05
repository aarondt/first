class Shop < ActiveRecord::Base

    has_many :weins, dependent: :destroy
    
    serialize :items
end
