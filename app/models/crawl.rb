class Crawl
     attr_accessor :name, :image_url, :price, :vintage,:failure
    
    
def create_shop
       @rewe = Shop.create(id: 1 ,shop_name: "REWE")
       @rewe.save
       
       @delinero = Shop.create(id: 2, shop_name: "Delinero")
       @delinero.save
       
       @vinos = Shop.create(id: 3, shop_name: "Vinos")
       @vinos.save
end

def count_values
    @start_value = (Wein.count('id', :distinct => false))
    return @start_value
end

def run_import()
    self.wein.destroy_all
    self.shop.destroy_all
    self.create_shop
    self.count_values
    self.crawl_new_wein
    self.count_values
    self.crawl_new_wein3
    return :class
end

def crawl_new_wein
    @rewe = Shop.create(id: 1 ,shop_name: "REWE")
       @rewe.save
       
    name = []
    source_link = []
    image_url = []
    price = []
    shop = []
    prod_mhd = []
    
   50.times do |d|
         url ="https://www.weinfreunde.de/weine-bestellen/?pagesize=12&sort=priceASC&allwines=rot&page=#{d+1}"
        page = Nokogiri::HTML(open(url))

        #name
        page.css('div.product-title').each do |line|
        name << line.text
        end
        
        #source_link
        page.css('div.rwf-po-article-gallery-item.rwf-special-hover.article-item a').map { |link| link['href'] }.each do |line|
        short_url = line
        url ="https://www.weinfreunde.de#{short_url}"
        source_link << url
        end
        
        #image_url
        page.css('div.rwf-imgholder img').map{ |i| i['src'] }.each do |line|
        image_url << line
        end
    
        #price
        page.css('span.rwf-price__amount.text-bold').each do |line|
       price_converted = line.text.sub(",",".")
        price2 = price_converted.sub("€","")
        price << price2
        end
        
        #Shop Name      
        vintage = []
        page.css('span.rwf-price__amount.text-bold').each do |line|
        vintage <<  "Weinfreunde.de REWE"
        end

        #Shop Logo
        page.css('div.product-title').each do |logo|
            logo['class']="rewe-logo"
         logo= 'https://www.weinfreunde.de/images/logo-weinfreunde.png'
         prod_mhd << logo
        
        end
     
        $item_count = source_link.length
            
    end
    
     
 
    # SAVING LOOP   
    $item_count.times do |lo|
        p "update started"
     #   index = lo
        
             
      rewe_wein = @rewe.weins.find_or_initialize_by(name: name[lo])
         # wein = shop.weins.find_or_initialize_by(id: start_value)
         rewe_wein.name = name[lo]
         rewe_wein.image_url = image_url[lo]
         #wein.vintage = vintage[i]
         rewe_wein.price = price[lo]
         rewe_wein.source_link = source_link[lo]
        # wein.prod_desc = prod_desc[i]
         #wein.prod_title = prod_title[i]
         #wein.prod_geschmack = taste[i]
         #wein.category = category[i]
         rewe_wein.prod_mhd = prod_mhd[lo]
         #if rewe_wein.exists?(:name => name[lo])
         #    next
        # else
        
        
        
         rewe_wein.save
        # end
    end
         
         
         
       
        p "reached end of migration"
      #  return true
        $already_run = 1
end

#DELINERO SHOP    
def crawl_new_wein2
    @delinero = Shop.find_or_initialize_by(id: 2, shop_name: "Delinero")
    
    
    vintage = []
    prod_desc = []
    price = []
    prod_title =[]
    taste =[]
    category = []
    prod_mhd = []
    name = []
    source_link = []
    image_url = []
     #157 pages in total
    
    5.times do |d|
    
        url ="https://www.delinero.de/wein-rot.html?dir=asc&order=price&p=#{d+1}"
        page = Nokogiri::HTML(open(url))
    
     
        page.css('div.product-info h2.product-name a').map{ |i| i['href'] }.each do |line|  
            source_link << line
        end
       
        page.css('h2.product-name a').each do |line|
        name << line.text
        end
        
       
        page.css('div.col4-set.product-overview-grid img').map{ |i| i['src'] }.each do |line|
        image_url << line
        end
        
        #     page.css('div.col4-set.product-overview-grid img').each do     
        #     if page.css('div.price-box span.regular-price span.price') 
        #         page.css('div.price-box span.regular-price span.price').each do |line|
        #             price_converted = line.text.gsub(/[[:space:]]/, "")
        #             price3 = price_converted.sub(",",".")
        #             price2 =price3.sub("EUR","")
        #             price << sprintf("€%2.2f", price2)
        #         end
        #     else
        #         page.css('div.price-box p.special-price').each do |specprice|
        #             price_converted = specprice.text.gsub(/[[:space:]]/, "")
        #             price3 = price_converted.sub(",",".")
        #             price2 = price3.sub("EUR","")
        #             price << sprintf("€%2.2f", price2)
        #         end
        #     end
        # end
            
       
        page.css('div.col4-set.product-overview-grid img').each do |line|
            
        category << 'Rotwein'    
        prod_mhd << 'https://www.delinero.de//skin/frontend/default/gourmet24/images/delinero_logo.png'
        end
            
            
    end
    
    
    source_link.length.times do |site|
      produkt_seite = Nokogiri::HTML(open(source_link[site]))
        
            #prod_desc << produkt_seite.css('div.std p').text
        
        #produkt_seite.css('div.col4-set.product-overview-grid img').each do     
            if produkt_seite.at_css('div.p-right-content div.price-box span.regular-price span.price') 
                produkt_seite.css('div.p-right-content div.price-box span.regular-price span.price').each do |line|
                    price_converted = line.text.gsub(/[[:space:]]/, "")
                    price3 = price_converted.sub(",",".")
                    price2 =price3.sub("EUR","")
                    price << price2
                    
                end
            else
                produkt_seite.css('div.p-right-content div.price-box p.special-price span.price').each do |specprice|
                    price_converted = specprice.text.gsub(/[[:space:]]/, "")
                    price3 = price_converted.sub(",",".")
                    price2 = price3.sub("EUR","")
                    price << price2
                end
            end
        #end
            
    end
        
    
           
            
      #      produkt_seite.css('div.price-box span.price').each do |ta|
      #          category << 'Rotwein'
         #   end
            #Shop Logo
            
        #   produkt_seite.css('div.p-right-content div.price-box span.regular-price span.price').each do |preis|
        #    price_converted = preis.text.gsub(/[[:space:]]/, "")
        #    price3 = price_converted.sub(",",".")
        #    price << price3.sub("EUR","")
       ##     p "added price"
         #   end     
 # end
    
    
    count =  source_link.length  
    @start_value = (Wein.count('id', :distinct => false))
        
    count.times do |i|
        index = @start_value + i
        delinero_wein = @delinero.weins.find_or_initialize_by(name: name[i])
        delinero_wein.name = name[i]
        delinero_wein.image_url = image_url[i]
        delinero_wein.source_link = source_link[i]
        delinero_wein.price = price[i]
        delinero_wein.prod_mhd = prod_mhd[i]
        if @delinero.weins.exists?(name: name[i]) 
          #if @delinero.weins.find_by(:name => name[i]).price == price[i]
           #  next
           #  else
                
           # end
            next
        else
        delinero_wein.save
        end
    end
end


# VINOS.DE SHOP
def crawl_new_wein3
    @vinos = Shop.create(id: 3, shop_name: "Vinos")
       @vinos.save
    #157 pages in total
    vintage = []
    prod_desc = []
    price = []
    prod_title =[]
    taste =[]
    category = []
    prod_mhd = []
    name = []
    source_link = []
    image_url = []
   
 50.times do |d|
    
        url ="http://www.vinos.de/weine/weiss/alle?p=#{d+1}"
        page = Nokogiri::HTML(open(url))
        
         
            
        #source_link = []
        page.css('div.module.border-r a').map { |link| link['href'] }.each do |line|
        produkt_link = line   
        source_link << produkt_link
        end
        
        page.css('div.module-media.border-b img').map{ |i| i['src'] }.each do |line|
               
        image_url << line
        end

 end
   
   $item_count2 = source_link.length
   
    source_link.length.times do |site|
        produkt_seite = Nokogiri::HTML(open(source_link[site]))
        
            produkt_seite.css('h3.h1.serif.italic.border-b.padding-b-small').each do |geschmack|
                vintage << geschmack.text
            end
            
            desc = produkt_seite.css('div#wineinfo div.column-right p').text
            if desc.empty? 
                desc = produkt_seite.css('div#wineinfo div.column-right').text
                prod_desc << desc
            else
                prod_desc << produkt_seite.css('div#wineinfo div.column-right p').text
            end
        
            produkt_seite.xpath('//dd[4]').each do |title|
                taste << title
            end
            produkt_seite.css('div#wineinfo div.column-right h3').each do |ta|
                name << ta.text
            end
            produkt_seite.css('div#wineinfo div.column-right h3').each do |ta|
                category << 'Weißwein'
            end
            #Shop Logo
            produkt_seite.css('div.header a.logo img').map{ |i| i['src'] }.each do |line|
                prod_mhd << line
            end
             
            produkt_seite.css('div.price-box span.final-price span.price').each do |preis|
                price_converted = preis.text.gsub(/[[:space:]]/, "")
                price2 = price_converted.to_s.gsub!(',', '.')
                price << price2
            end     
    end
    
    #Zählt alle Items des letzten Updates - wird benötigt um den Index für ID zu setzten, um dort fortzuführen wo die letzte migration endete
    
    @start_value = (Wein.count('id', :distinct => false))
        
    $item_count2.times do |lo|
    p lo
        index = @start_value + lo
         p "first run"
   # end
     #  wein = Wein.find_or_initialize_by(id: index, shop_id: 2)
        vinos_wein = @vinos.weins.find_or_initialize_by(name: name[lo])
            vinos_wein.name = name[lo]
            vinos_wein.image_url = image_url[lo]
            vinos_wein.price = price[lo]
            vinos_wein.source_link = source_link[lo]
            vinos_wein.prod_mhd = prod_mhd[lo]
            vinos_wein.save
            
    end
end
   
   
   
   def bxum
    @vinello = Shop.find_or_initialize_by(id: 2, shop_name: "Vinello")
    
    
    vintage = []
    prod_desc = []
    price = []
    prod_title =[]
    taste =[]
    category = []
    prod_mhd = []
    name = []
    source_link = []
    image_url = []
     #157 pages in total
    
   3.times do |d|
    
        url ="http://bxum.com/search-videos?q=tease+and+denial&p=#{d + 1}"
        page = Nokogiri::HTML(open(url))
    
     
        page.xpath('//*[@id="page-wrapper"]/section/div[2]/article/div/div[1]/a/img').each do |line|  
    
        
            source_link << line['href']
           
           
        end
       
        page.xpath('//*[@id="page-wrapper"]/section/div[2]/article/div/h3').each do |line|
            
        name << line.text
        end
      
       
         
        page.xpath('//*[@id="page-wrapper"]/section/div[2]/article/div/div[1]/a/img').each do |line|
            
          
        img = line['data-original']
       # img.gsub!(/,.*/, '')
        image_url << img
        end
        
          
    end
    
    
    
           
            
      #      produkt_seite.css('div.price-box span.price').each do |ta|
      #          category << 'Rotwein'
         #   end
            #Shop Logo
            
        #   produkt_seite.css('div.p-right-content div.price-box span.regular-price span.price').each do |preis|
        #    price_converted = preis.text.gsub(/[[:space:]]/, "")
        #    price3 = price_converted.sub(",",".")
        #    price << price3.sub("EUR","")
       ##     p "added price"
         #   end     
 # end
    
    
    count =  source_link.length  
        
    count.times do |i|
    
        delinero_wein = @vinello.weins.find_or_initialize_by(name: name[i])
        delinero_wein.name = name[i]
        delinero_wein.image_url = image_url[i]
        delinero_wein.source_link = source_link[i]
        delinero_wein.price = price[i]
        delinero_wein.prod_mhd = prod_mhd[i]
        if @vinello.weins.exists?(name: name[i]) 
         
            next
        else
        delinero_wein.save
        end
    end
end


def crawl_new_wein5
    @edeka = Shop.find_or_initialize_by(id: 5, shop_name: "Edeka")
    
    
    vintage = []
    prod_desc = []
    price = []
    prod_title =[]
    taste =[]
    category = []
    prod_mhd = []
    name = []
    source_link = []
    image_url = []
     #157 pages in total
    
    30.times do |d|
    
        url ="https://www.edeka24.de/Getraenke/Italienische+Weine/?force_sid=1kj4rsul11qe9156s1cv2jll11"
        page = Nokogiri::HTML(open(url))
    
     p "h1"
        page.css('//*[@id="mainContent"]/div[2]/div/div[1]/a/@href').each do |line|  
            source_link << line
        end
     p "h2"  
        page.css('div.product-top-box h2 a span').each do |line|
        name << line.text
        end
        
        counter = name.length
        
    p "h3"   
        page.xpath('//*[@id="mainContent"]/div[2]/div/div[1]/a/img').each   do |i|
        
        image_url << i['src']
        end
    p "h4"    
         page.xpath('//*[@id="mainContent"]/div[2]/div/div[2]/div[2]/div').each do |preis|
                price_converted = preis.text.gsub(/[[:space:]]/, "")
                price2 = price_converted.gsub(',', '.')
                #price2 = price2.sub("€*","")
                 
            price << price2.to_f
            
        end     
        
      
    p "h5"        
       
        name.length.times do |line|
            
        category << 'Rotwein'    
        prod_mhd << 'https://cdn-1.vetalio.de/media/catalog/product/cache/1/logo/150x100/9df78eab33525d08d6e5fb8d27136e95/e/d/edeka24.png'
        end
            
            
    end
    
    
    
           
    
    count =  source_link.length  
    
    count.times do |i|
    
        delinero_wein = @edeka.weins.find_or_initialize_by(name: name[i])
        delinero_wein.name = name[i]
        p "h1"
        delinero_wein.image_url = image_url[i]
        p "h2"
        delinero_wein.source_link = source_link[i]
        p "h3"
        delinero_wein.price = price[i]
        p "h4"
        delinero_wein.prod_mhd = prod_mhd[i]
        p "h5"
        if @edeka.weins.exists?(name: name[i]) 
         
            next
        else
        
            
        delinero_wein.save
        end
        
    end
end


def crawl_new_wein4
    @vinello = Shop.find_or_initialize_by(id: 4, shop_name: "txxx")
    
    
    vintage = []
    prod_desc = []
    price = []
    prod_title =[]
    taste =[]
    category = []
    prod_mhd = []
    name = []
    source_link = []
    image_url = []
     #157 pages in total
    
   30.times do |d|
    
        url ="http://www.txxx.com/search/?s=tease+and+denial"
        page = Nokogiri::HTML(open(url))
    
     
        page.xpath('//*[@id="list_videos2_common_videos_list_items"]/div/div/a').each do |line|  
        
        
            source_link << line['href']
           
           
        end
       
        page.xpath('//*[@id="list_videos2_common_videos_list_items"]/div/div/a').each do |line|
            
        name << line.text
        end
        
        
         
        page.xpath('//*[@id="list_videos2_common_videos_list_items"]/div/div/div[1]/a/img').each do |line|
            
          
        img = line['src'].to_s
       # img.gsub!(/,.*/, '')
        image_url << img
        end
        
          
    end
    
    
    
           
            
      #      produkt_seite.css('div.price-box span.price').each do |ta|
      #          category << 'Rotwein'
         #   end
            #Shop Logo
            
        #   produkt_seite.css('div.p-right-content div.price-box span.regular-price span.price').each do |preis|
        #    price_converted = preis.text.gsub(/[[:space:]]/, "")
        #    price3 = price_converted.sub(",",".")
        #    price << price3.sub("EUR","")
       ##     p "added price"
         #   end     
 # end
    
    
    count =  source_link.length  
        
    count.times do |i|
    
        delinero_wein = @vinello.weins.find_or_initialize_by(name: name[i])
        delinero_wein.name = name[i]
        delinero_wein.image_url = image_url[i]
        delinero_wein.source_link = source_link[i]
        delinero_wein.price = price[i]
        delinero_wein.prod_mhd = prod_mhd[i]
        
        delinero_wein.save
    
    end
end


def crawl_new_wein5
    @edeka = Shop.find_or_initialize_by(id: 5, shop_name: "Edeka")
    
    
    vintage = []
    prod_desc = []
    price = []
    prod_title =[]
    taste =[]
    category = []
    prod_mhd = []
    name = []
    source_link = []
    image_url = []
     #157 pages in total
    
    30.times do |d|
    
        url ="https://www.edeka24.de/Getraenke/Italienische+Weine/?force_sid=1kj4rsul11qe9156s1cv2jll11"
        page = Nokogiri::HTML(open(url))
    
     p "h1"
        page.css('//*[@id="mainContent"]/div[2]/div/div[1]/a/@href').each do |line|  
            source_link << line
        end
     p "h2"  
        page.css('div.product-top-box h2 a span').each do |line|
        name << line.text
        end
        
        counter = name.length
        
    p "h3"   
        page.xpath('//*[@id="mainContent"]/div[2]/div/div[1]/a/img').each   do |i|
        
        image_url << i['src']
        end
    p "h4"    
         page.xpath('//*[@id="mainContent"]/div[2]/div/div[2]/div[2]/div').each do |preis|
                price_converted = preis.text.gsub(/[[:space:]]/, "")
                price2 = price_converted.gsub(',', '.')
                #price2 = price2.sub("€*","")
                 
            price << price2.to_f
            
        end     
        
      
    p "h5"        
       
        name.length.times do |line|
            
        category << 'Rotwein'    
        prod_mhd << 'https://cdn-1.vetalio.de/media/catalog/product/cache/1/logo/150x100/9df78eab33525d08d6e5fb8d27136e95/e/d/edeka24.png'
        end
            
            
    end
    
    
    
           
    
    count =  source_link.length  
    
    count.times do |i|
    
        delinero_wein = @edeka.weins.find_or_initialize_by(name: name[i])
        delinero_wein.name = name[i]
        p "h1"
        delinero_wein.image_url = image_url[i]
        p "h2"
        delinero_wein.source_link = source_link[i]
        p "h3"
        delinero_wein.price = price[i]
        p "h4"
        delinero_wein.prod_mhd = prod_mhd[i]
        p "h5"
        if @edeka.weins.exists?(name: name[i]) 
         
            next
        else
        
            
        delinero_wein.save
        end
        
    end
end


def crawl_new_wein6
    @vinello = Shop.find_or_initialize_by(id: 6, shop_name: "xxxjojo")
    
    #83 seiten vorhanden
    vintage = []
    prod_desc = []
    price = []
    prod_title =[]
    taste =[]
    category = []
    prod_mhd = []
    name = []
    source_link = []
    image_url = []
     #157 pages in total
    
   83.times do |d|
    
        url ="http://www.xxxjojo.com/top-handjob-edging-cum-tease-tubes/page/#{d + 1}/"
        page = Nokogiri::HTML(open(url))
    
        page.xpath('/html/body/main/div[2]/div/div[1]/a').each do |line|  
        
        
            source_link << line['href']
           
           
        end
       
        page.xpath('/html/body/main/div[2]/div/div[1]/a/img').each do |line|
          
            
        name2 = line['alt']
        name << name2[0..80].gsub(/\s\w+\s*$/,'...')
        end
        
        
        page.css('.duration').each do |line|
            
        prod_title << line.text
        end
        
         
        page.xpath('/html/body/main/div[2]/div/div[1]/a/img').each do |line|
            
          
        img = line['src'].to_s
      # img.gsub!(/,.*/, '')
        image_url << img
        end
        
          
    end
    
    
    
           
            
      #      produkt_seite.css('div.price-box span.price').each do |ta|
      #          category << 'Rotwein'
         #   end
            #Shop Logo
            
        #   produkt_seite.css('div.p-right-content div.price-box span.regular-price span.price').each do |preis|
        #    price_converted = preis.text.gsub(/[[:space:]]/, "")
        #    price3 = price_converted.sub(",",".")
        #    price << price3.sub("EUR","")
       ##     p "added price"
         #   end     
 # end
    
    
    count =  source_link.length  
        
    count.times do |i|
    
        delinero_wein = @vinello.weins.find_or_initialize_by(name: name[i])
        delinero_wein.name = name[i]
        delinero_wein.image_url = image_url[i]
        delinero_wein.source_link = source_link[i]
        delinero_wein.prod_title = prod_title[i]
        delinero_wein.price = price[i]
        delinero_wein.prod_title = prod_title[i]
        if @vinello.weins.exists?(name: name[i]) 
         
            next
        else
        delinero_wein.save
        end
    end
end


def crawl_new_wein7
    @mark = Shop.find_or_initialize_by(id: 13, shop_name: "MarksHead")
    
    
    vintage = []
    prod_desc = []
    price = []
    prod_title =[]
    taste =[]
    category = []
    prod_mhd = []
    name = []
    source_link = []
    image_url = []
     #157 pages in total
    
   1.times do |d|
    
        url ="http://95.211.228.117/video/Marks%20Head%20Bobbers"
        page = Nokogiri::HTML(open(url))
    
     
        page.xpath('//*[@id="nifty"]/a').each do |line|  
        
            source_link << line['href']
           
           
        end
        
        page.css('#nifty a').each do |line|
         line2 =   line.text[0..80].gsub(/\s\w+\s*$/,'...')
        name << line2
        end
       
       page.css('.sortable-item font').each do |t|
           prod_title << t.text
        end
        # page.xpath('//li/a/img').each do |line|
          
            
        # name << line['alt']
        # end
        
        
        # page.xpath('//*/li/a/img').each do |line|
        page.css('li img').each do |line|  
          
        img = line['src']
      # img.gsub!(/,.*/, '')
        image_url << img
        end
         
        
        
          
    end
    
    #   $item_count2 = source_link.length
   
    # source_link.length.times do |site|
    #     produkt_seite = Nokogiri::HTML(open("http://daftsex.com/#{source_link[site]}"))
      
        
        
    # end
    
    
    
           
            
      #      produkt_seite.css('div.price-box span.price').each do |ta|
      #          category << 'Rotwein'
         #   end
            #Shop Logo
            
        #   produkt_seite.css('div.p-right-content div.price-box span.regular-price span.price').each do |preis|
        #    price_converted = preis.text.gsub(/[[:space:]]/, "")
        #    price3 = price_converted.sub(",",".")
        #    price << price3.sub("EUR","")
       ##     p "added price"
         #   end     
 # end
    
    
    count =  source_link.length  
        
    count.times do |i|
    
        mark_video = @mark.weins.find_or_initialize_by(source_link: source_link[i])
        mark_video.name = name[i]
        mark_video.image_url = image_url[i]
        mark_video.source_link = "http://95.211.228.117#{source_link[i]}"
        mark_video.price = price[i]
        mark_video.prod_title = prod_title[i]
       
       mark_video.save
        
    end
end



def crawl_new_wein8
    @vinello = Shop.find_or_initialize_by(id: 8, shop_name: "MarksHead")
    
    
    vintage = []
    prod_desc = []
    price = []
    prod_title =[]
    taste =[]
    category = []
    prod_mhd = []
    name = []
    source_link = []
    image_url = []
     #157 pages in total
    #23
   23.times do |d|
    
        url ="http://www.pussyspace.com/search?q=tease+and+denial&page=#{d +1}"
        page = Nokogiri::HTML(open(url))
    
     
        page.xpath('//*[@id="video_content"]/div/div/a').each do |line|  
        
            source_link << line['href']
           
           
        end
       
        page.xpath('//*[@id="video_content"]/div/div/a').each do |line|
          
            
        name2 =line['title']
        line2 =   name2[0..80].gsub(/\s\w+\s*$/,'...')
        name << line2
        end
        
          
         page.xpath('//*[@id="video_content"]/div/a/img').each do |line|
            
          
        img = line['src']
      # img.gsub!(/,.*/, '')
        image_url << img
        end
         
        page.css('.video_duration').each do |t|
            prod_title << t.text
        end
        
        
          
    end
    
    #   $item_count2 = source_link.length
   
    # source_link.length.times do |site|
    #      produkt_seite = Nokogiri::HTML(open("http://www.pussyspace.com/#{source_link[site]}"))
    #   produkt_seite.xpath('param[5]').each do |line|
    #         player = line['value']
    #         prod_desc << player
    #     end
        
    #  end
    
    
    
           
            
      #      produkt_seite.css('div.price-box span.price').each do |ta|
      #          category << 'Rotwein'
         #   end
            #Shop Logo
            
        #   produkt_seite.css('div.p-right-content div.price-box span.regular-price span.price').each do |preis|
        #    price_converted = preis.text.gsub(/[[:space:]]/, "")
        #    price3 = price_converted.sub(",",".")
        #    price << price3.sub("EUR","")
       ##     p "added price"
         #   end     
 # end
    
    
    count =  source_link.length  
        
    count.times do |i|
    
        delinero_wein = @vinello.weins.find_or_initialize_by(source_link: source_link[i])
        delinero_wein.name = name[i]
        delinero_wein.image_url = image_url[i]
        delinero_wein.source_link = "http://www.pussyspace.com/#{source_link[i]}"
        delinero_wein.price = price[i]
        delinero_wein.prod_title = prod_title[i]
        delinero_wein.prod_desc = prod_desc[i]
       
        delinero_wein.save
        
    end
end
def crawl_new_wein10
    @xvid = Shop.find_or_initialize_by(id: 10, shop_name: "xhamster")
    
    
    vintage = []
    prod_desc = []
    price = []
    prod_title =[]
    taste =[]
    category = []
    prod_mhd = []
    name = []
    source_link = []
    image_url = []
     #157 pages in total
    
   130.times do |d|
    
        #url ="http://de.xhamster.com/new/#{d + 1}.html"
        url = "http://de.xhamster.com/search.php?q=tease+and+denial&qcat=video&page=#{d + 1}"
        page = Nokogiri::HTML(open(url))
    
     
        page.css('.video a').each do |line|  
        
            source_link << line['href']
           
           
        end
       
        # page.xpath('//li/a/img').each do |line|
          
            
        # name << line['alt']
        # end
        
        
        # page.xpath('//*/li/a/img').each do |line|
        page.css('.video a img').each do |line|  
          
        img = line['src']
      # img.gsub!(/,.*/, '')
        image_url << img
        end
          page.css('.hRotator u').each do |ta|
              line2 =   ta.text
        name << line2
              
            end
            
         page.css('.hRotator b').each do |ta|
                prod_title << ta.text
            end
            
            
        #vPromo > div.boxC > div:nth-child(1) > a > u
        
          
    end
    
    #   $item_count2 = source_link.length
   
    # source_link.length.times do |site|
    #     produkt_seite = Nokogiri::HTML(open("http://daftsex.com/#{source_link[site]}"))
      
        
        
    # end
    
    
    
           
            
      #      produkt_seite.css('div.price-box span.price').each do |ta|
      #          category << 'Rotwein'
         #   end
            #Shop Logo
            
        #   produkt_seite.css('div.p-right-content div.price-box span.regular-price span.price').each do |preis|
        #    price_converted = preis.text.gsub(/[[:space:]]/, "")
        #    price3 = price_converted.sub(",",".")
        #    price << price3.sub("EUR","")
       ##     p "added price"
         #   end     
 # end
    
    
    count =  source_link.length  
        
    count.times do |i|
    
        mark_video = @xvid.weins.find_or_initialize_by(source_link: source_link[i])
        mark_video.name = name[i]
        mark_video.image_url = image_url[i]
        mark_video.source_link = "#{source_link[i]}"
        mark_video.price = price[i]
        mark_video.prod_mhd = prod_mhd[i]
        mark_video.prod_title = prod_title[i]
        if mark_video.image_url.include? ".gif"
         next
        else
         mark_video.save
        end
        
    end
end



#end of all
end
