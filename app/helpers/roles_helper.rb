module RolesHelper
    def role_status(enabled)
        if enabled
            "<span class='badge bg-success' style='width: 30px'>Sí</span>".html_safe
        else
            "<span class='badge bg-warning' style='width: 30px'>No</span>".html_safe
        end
    end
end
