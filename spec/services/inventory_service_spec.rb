# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InventoryService do
  describe '.update_inventory' do
    let(:character) { create(:character) }
    let(:item_id) { 1 }
    let(:quantity_change) { 5 }

    context 'when inventory item exists' do
      it 'updates the inventory item' do
        item = create(:item)
        inventory_item = create(:inventory, character:, item:, quantity: 10)

        expect do
          InventoryService.update_inventory(character, item.id, quantity_change)
          inventory_item.reload
        end.to change(inventory_item, :quantity).by(quantity_change)
      end
    end

    context 'when inventory item does not exist and quantity change is positive' do
      it 'creates a new inventory item' do
        item = create(:item) # Create a new Item object
        expect do
          InventoryService.update_inventory(character, item.id, quantity_change)
        end.to change(Inventory, :count).by(1)
      end
    end

    context 'when inventory item does not exist and quantity change is zero' do
      it 'does not create a new inventory item' do
        expect do
          InventoryService.update_inventory(character, item_id, 0)
        end.not_to change(Inventory, :count)
      end
    end
  end

  describe '.update_or_log_error' do
    let(:inventory_item) { create(:inventory, quantity: 10) }

    context 'when new_quantity is greater than or equal to 0' do
      it 'updates the inventory item with the new quantity' do
        new_quantity = 15

        expect do
          InventoryService.update_or_log_error(inventory_item, new_quantity, inventory_item.item_id)
          inventory_item.reload
        end.to change(inventory_item, :quantity).to(new_quantity)
      end
    end

    context 'when new_quantity is less than 0' do
      it 'raises a NegativeInventoryError and does not update the quantity' do
        new_quantity = -5

        expect do
          expect do
            InventoryService.update_or_log_error(inventory_item, new_quantity, inventory_item.item_id)
            inventory_item.reload
          end.to raise_error(NegativeInventoryError)
        end.not_to change(inventory_item, :quantity)
      end
    end
  end

  describe '.inventory_for' do
    let(:character) { create(:character) }
    let(:item1) { create(:item, name: 'Item 1') }
    let(:item2) { create(:item, name: 'Item 2') }

    context 'when character has inventories' do
      it 'returns a hash of item names and their quantities' do
        create(:inventory, character:, item: item1, quantity: 5)
        create(:inventory, character:, item: item2, quantity: 10)

        result = InventoryService.inventory_for(character)

        expect(result).to be_a(Hash)
        expect(result).to include('Item 1' => 5, 'Item 2' => 10)
      end
    end

    context 'when character has no inventories' do
      it 'returns an empty hash' do
        result = InventoryService.inventory_for(character)

        expect(result).to be_a(Hash)
        expect(result).to be_empty
      end
    end
  end
end
