class CreateSongsTable < ActiveRecord::Migration[5.1]
  def change 
    create_table :songs do |t|
      t.integer :year, :rank
      t.string :title, :artist, :country, :videoid, :image, :title_slug, :country_slug, :artist_slug
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end