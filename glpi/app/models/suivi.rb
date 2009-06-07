class Suivi < ActiveRecord::Base
  establish_connection configurations['glpi']
  set_table_name "glpi_followups"
  set_primary_key "ID"
  belongs_to :ticket, :foreign_key => "tracking"
end
