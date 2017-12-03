class AddTwitterInfoToSeller < ActiveRecord::Migration[5.1]
  def change
    add_column :sellers, :twitter_id, :integer
    add_column :sellers, :twitter_name, :string
    add_column :sellers, :twitter_screen_name, :string
    add_column :sellers, :twitter_image_url, :string
    add_column :sellers, :twitter_token, :string
    add_column :sellers, :twitter_secret, :string
  end
end
