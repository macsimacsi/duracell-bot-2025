module ParticipantsHelper
  def participation_status(p)
    case p.status
    when 0
      "<span style='background-color: #fafc9f; padding: 5px; color: black; border-radius: 10px;'>Pendiente</span>".html_safe
    when 1
      "<span style='background-color: green; padding: 5px; color: white; border-radius: 10px;'>Aprobado</span>".html_safe
    when 2
      "<span style='background-color: red; padding: 5px; color: white; border-radius: 10px;'>No aprobado</span>".html_safe
    end
  end
end
