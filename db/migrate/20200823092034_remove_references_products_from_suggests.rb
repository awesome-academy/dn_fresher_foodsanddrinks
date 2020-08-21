class RemoveReferencesProductsFromSuggests < ActiveRecord::Migration[6.0]
  def change
    remove_reference :suggests, :product
  end
end
