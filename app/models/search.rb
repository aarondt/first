class Search < ActiveRecord::Base

def search_wines
    
    weine = Wein.all.order(:price)
    
    weine = weine.where(["name LIKE ?", "%#{keywords}%"]) if keywords.present?
    weine = weine.where(["category LIKE ?", category]) if category.present?
    weine = weine.where(["price >= ?", min_price]) if min_price.present?
    weine = weine.where(["price <= ?", max_price]) if max_price.present?
    weine = weine.where(["vintage LIKE ?", vintage]) if vintage.present?
    
    
    return weine
end

    
    
end
