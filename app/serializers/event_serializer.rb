class EventSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :event_items
  
  class EventItemSerializer < ActiveModel::Serializer
    attributes :price
    attribute :item_id
    attribute :name
    attribute :count
    
    def item_id
      object.item.id
    end
    
    def name
      object.item.name
    end

    def count
      logs = Log.where(event_item_id: object.id)
      if logs.empty?
        nil
      else
        logs.sum(:diff_count)
      end
    end
  end
end
