require 'gruff'
class IndicateurQController < ApplicationController
  
  def incidents
    #Recherche tous les tickets d'incidents clos pendant la periode intervalle
    @incidents_clos=Ticket.get_tickets :status=>"fermé",\
                                       :famille=>"incident",\
                                       :debut=>params[:debut],\
                                       :fin=>params[:fin]

    #graphique=(params[:graphique] || false)
    @incidents_clos=@incidents_clos.find_all {|incident| incident.technicien.name=='wsanzey'}
    duree_max=(params[:duree_max] || 86400)
    #Recherce les incidents fermés en moins de duree_max
    @incidents_q=@incidents_clos.find_all{ |incident| incident.duration <= duree_max}
    graph=Gruff::Pie.new()
    graph.title="Incidents"
    graph.data  "Traités en moins de 24H", @incidents_q.count
    graph.data "Traités en plus de 24H" , @incidents_clos.count-@incidents_q.count
    graph.write "public/images/indicateur_q_incidents.png"
    @indicateur=@incidents_q.count.to_f/@incidents_clos.count
  end

  def reaction
    @tickets_clos=Ticket.get_tickets :status=>"fermé",\
      :debut=>params[:debut],\
      :fin=>params[:fin]
    #graphique=(params[:graphique] || false)
    duree_max=(params[:duree_max] || 14400)
    @tickets_q=[]
    @tickets_clos.each do |ticket|
      begin
        duree=ticket.suivis.first.date-ticket.date
      rescue
        duree=ticket.closedate-ticket.date
      end
      @tickets_q << ticket if duree <= duree_max
    end
    graph=Gruff::Pie.new
    graph.title="Temps de réaction"
    graph.data  "Moins de 4H", @tickets_q.count
    graph.data "Plus de 4H" , @tickets_clos.count-@tickets_q.count
    graph.write "indicateur_q_reaction.png"
    @indicateur=@tickets_q.count.to_f/@tickets_clos.count
  end
  def hh(value)
    h value
  end
end
