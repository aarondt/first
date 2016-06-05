class Wein < ActiveRecord::Base

  #  def self.search(search)
 #       if search
   #         where(["name LIKE ?","%#{params[:search]}%"]).order("price ASC")
  #      else all
 #       end
 #   end
 
# self.default_scope order('price') 




belongs_to :shop
end
