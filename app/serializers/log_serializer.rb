class LogSerializer < ActiveModel::Serializer
  attributes :id, :diff_count, :created_at, :updated_at
  has_one :event_item, key: :id
end
