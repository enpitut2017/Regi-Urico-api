class EventSerializer < ActiveModel::Serializer
  attributes :id, :name
  
  # --- JSONのkeyをitemsにできるがitem_idから紐づくitems情報を取得する方法がわからない ---
  # attribute :evis, key: :items
  # def evis
  #   object.event_items
  # end
  
  # --- JSONのevent_itemsの中身のitem情報をpriceと同じ階層に表示できるが、JSONのkey名が公式のページに書いてあるやり方で変えられない ---
  has_many :event_items
  class EventItemSerializer < ActiveModel::Serializer
    attributes :price
    attribute :item_id
    attribute :name
    
    def item_id
      object.item.id
    end
    
    def name
      object.item.name
    end
  end
end
