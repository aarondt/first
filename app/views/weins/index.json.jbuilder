json.array!(@weins) do |wein|
  json.extract! wein, :id, :name, :image_url, :price, :vintage
  json.url wein_url(wein, format: :json)
end
