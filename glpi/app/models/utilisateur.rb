class Utilisateur < ActiveRecord::Base
  establish_connection configurations['glpi']
  set_table_name "glpi_users"
  #la clef primaire est ID et non id
  set_primary_key "ID"
  #La liste des tickets associés à l'utilisateur
  has_many :tickets, :foreign_key => "recipient", :order=>'date'
  #La liste des interventions d'un technicien
  has_many :interventions, :class_name => "Ticket", :foreign_key => "assign", :order=>'date'
end
