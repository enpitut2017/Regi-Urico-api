class SellerSerializer < ActiveModel::Serializer
  attributes :id, :name, :token, :twitter_name, :twitter_screen_name, :twitter_image_url
end
