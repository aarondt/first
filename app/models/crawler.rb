require 'open-uri'
require 'nokogiri'
require 'csv'
require 'mechanize'

url ="http://editorial.rottentomatoes.com/article/awards-leaderboard-2015/"
page = Nokogiri::HTML(open(url))

p "Crawler Start"

title = []
page.css('div.col-sm-17.article_movie_title h2 a').each do |line|
    title << line.text
end

rating = []
page.css('div.col-sm-17.article_movie_title h2 span.tMeterScore').each do |line|
    rating << line.text
end

wins = []
page.css('div.col-sm-17 span.count').each do |line|
    winsConverted = line.text.gsub(/[[:space:]]+/,"").to_i
    wins << winsConverted
end

# in csv Datei schreiben


CSV.open("file.csv", "w") do |file|
    
    file << ["Film Titel", "Bewertung", "Awards"]
    
    #daten aus array schreiben
    title.length.times do |i|
        file << [title[i], rating[i], wins[i]]
    end
end


#code
#title = page.css('div.col-sm-17.article_movie_title h2 a').text
#rating = page.css('div.col-sm-17.article_movie_title h2 span.tMeterScore').text
#wins = page.css('div.col-sm-17 span.count').text

p title 
p rating
p wins
