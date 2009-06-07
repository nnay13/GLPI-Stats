class Ticket < ActiveRecord::Base
  establish_connection configurations['glpi']
  
  set_table_name  "glpi_tracking"
  #la clef primaire est ID et non id
  set_primary_key "ID"
  #L'utilisateur propriétaire du ticket
  belongs_to :utilisateur, :foreign_key => "recipient"
  #Le technicien traitant le ticket
  belongs_to :technicien, :class_name => "Utilisateur", :foreign_key => "assign"
  #La catégorie du Ticket
  belongs_to :categorie, :foreign_key => "category"
  has_many :suivis, :foreign_key => "tracking", :order =>"date"
  #Constantes

  #Calcul de la durée de l'intervention en secondes
  def duration
    #Si l'incident n'est pas terminé, on calcule à partir de maintenant
    if self.closedate == nil
      fin = Time.now
    else
      fin = self.closedate
    end
    fin - self.date
  end
  #Retourne une liste de ticket avec un filtrage particulier
  #
  # :famille=>  "tous" tous les tickets (par défaut)
  #               "incident"  tous les incidents
  #               "changements" les demandes de changement
  #
  # :status=> "fermé"  les tickets fermés
  #               "ouvert" les tickets ouverts
  #               "indifférent" les tickets ouvert et les tickets fermés(par défaut)

  def self.get_tickets(params={})
    status = params[:status]
    status = "indifférent" if not ["indifférent","ouvert","fermé",false].include?(status)
    famille = params[:famille] || "tous"
    famille = "tous" if not (["incident","tous","changement"].include?(famille))
    fin = if params[:fin].nil? 
            Time.now
          else
            Time.parse params[:fin]
          end
    debut = if params[:debut].nil?
              Time.now - 56.days
            else
              Time.parse params[:debut]
            end
    range = "#{(debut..fin).to_s(:db)}"
    
    if famille == "tous"
      case status 
      when "fermé"
        condition = "closedate #{range}"
      when "ouvert"
        condition = "date #{range} AND closedate IS NULL"
      when "indifférent"
        condition = "date #{range}" 
      end
      return Ticket.find(:all,:order=>:date,:conditions=>["#{condition}"])
    end
    
    if famille == "incident"
      incidentID = Categorie.find_by_name("Incident informatique").ID
      case status 
      when "fermé"
        condition = "category=#{incidentID} AND closedate #{range}"
      when "ouvert"
        condition = "category=#{incidentID} AND date #{range} AND closedate IS NULL "
      when "indifférent"
        condition = "category=#{incidentID} AND date #{range}" 
      end
      return Ticket.find(:all, :conditions=>["#{condition}"])
    end
    
    if famille == "changement"
      chgmtID = Categorie.find_by_name("Demande de changement").ID
      case status
      when "fermé"
        condition1 = "glpi_dropdown_tracking_category.parentID=#{chgmtID}"
        condition1 = condition1 +" AND closedate #{range}"
        condition2 = "category=#{chgmtID}"
        condition2 = condition2 +" AND closedate #{range}" 
      when "indifférent"
        condition1 = "glpi_dropdown_tracking_category.parentID=#{chgmtID}"
        condition1 = condition1 +" AND date #{range}"
        condition2 = "category=#{chgmtID}"
        condition2 = condition2 +" AND date #{range}" 
      when "ouvert"
        condition1 = "glpi_dropdown_tracking_category.parentID=#{chgmtID}"
        condition1 = condition1 +" AND date #{range} AND closedate IS NULL"
        condition2 = "category=#{chgmtID}"
        condition2 = condition2 +" AND date #{range} AND closedate IS NULL" 
      end
      changements = Ticket.find(:all, \
                                :include => {:categorie=>{}} ,\
                                :conditions=> ["#{condition1}"])
      return changements+Ticket.find(:all, :conditions=>["#{condition2}"])
    end
  end
end
