class Categorie < ActiveRecord::Base
  establish_connection configurations['glpi']
  set_table_name "glpi_dropdown_tracking_category"
  set_primary_key "ID"
  #Liste des tickets appartenant à cette catégorie
  has_many :tickets,  :foreign_key => "category"
  #la catégorie parente | nil si pas de parent
  belongs_to :parent, :class_name => "Categorie", :foreign_key => "parentID"
end
