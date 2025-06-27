module WinnersHelper
    def winner_status(w)
        case w.status
        when 'new_'
            "<span style='background-color: #fafc9f; padding: 5px; color: black; border-radius: 10px;'>A confirmar</span>".html_safe
        when 'confirmed_'
            "<span style='background-color: green; padding: 5px; color: white; border-radius: 10px;'>Confirmado</span>".html_safe
        when 'delivered_'
            "<span style='background-color: lightblue; padding: 5px; color: white; border-radius: 10px;'>Entregado</span>".html_safe
        else
            "#{w.status}"
        end
    end
end
