class Inventory < ApplicationRecord
  belongs_to :owner, class_name: 'Character', foreign_key: 'owner_id'
end
