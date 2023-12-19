class AddDataTypeToSpreeTaxon < ActiveRecord::Migration[7.0]
  def change
    add_column :spree_taxons, :data_type, :integer
  end
end
