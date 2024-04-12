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
        initial_quantity = inventory_item.quantity

        InventoryService.update_inventory(character, item.id, quantity_change)

        expect(inventory_item.quantity).to eq(initial_quantity)
        inventory_item.reload
        expect(inventory_item.quantity).not_to eq(initial_quantity)
      end
    end
    context 'when inventory item does not exist and quantity change is positive' do
      it 'creates a new inventory item' do
        item = create(:item)
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
        inventory_item = create(:inventory, quantity: 10)
        new_quantity = -5

        expect do
          InventoryService.update_or_log_error(inventory_item, new_quantity, inventory_item.item_id)
        end.to raise_error(NegativeInventoryError)

        inventory_item.reload
        expect(inventory_item.quantity).to eq(10)
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
  let!(:character) { create(:character) }
  let!(:item) { create(:item) }

  describe '.set_inventory' do
    context 'when the item exists' do
      it 'creates or updates the inventory item for the character' do
        expect do
          described_class.set_inventory(character, item.id, 5)
        end.to change { character.inventories.count }.by(1)

        inventory_item = character.inventories.find_by(item:)
        expect(inventory_item.quantity).to eq(5)
      end
    end

    context 'when the item does not exist' do
      it 'does not create or update any inventory items' do
        non_existing_item_id = item.id + 1 # Assuming this ID does not exist
        expect do
          described_class.set_inventory(character, non_existing_item_id, 5)
        end.not_to(change { character.inventories.count })
      end
    end
  end
end
