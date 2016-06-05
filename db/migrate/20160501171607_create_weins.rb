class CreateWeins < ActiveRecord::Migration
  def change
    create_table :weins do |t|
      t.string :name
      t.string :image_url
      t.float :price
      
      t.string :source_link
      t.string :vintage
      t.string :category
      
      t.string :prod_title
      t.string :prod_desc
      t.string :prod_inhalt
      t.string :prod_alcgehalt
      t.string :prod_geschmack
      t.string :prod_mhd
      t.string :prod_verschluss
      t.string :prod_winemaker
      t.string :prod_trinktemp
      t.string :prod_anbaugebiet
      t.string :prod_herstellerfirma
      t.string :prod_abfueller
      t.string :prod_allergene
      t.string :prod_rebsorte
      
      
      
      t.timestamps null: false
      
       t.belongs_to :shop , index: true
    end
  end
end
