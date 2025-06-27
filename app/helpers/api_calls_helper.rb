module ApiCallsHelper
    def api_call_method(api_call)
        "<span class='badge bg-primary gd-admin-index-icon-margin'>#{api_call.method}</span>".html_safe
    end

    def api_call_response_code(api_call)
        case api_call.response_code.to_i
        when 200, 201, 204
            "<span class='badge bg-success'>#{api_call.response_code}</span> ".html_safe
        else
            "<span class='badge bg-danger'>#{api_call.response_code}</span> ".html_safe            
        end
    end

    def api_call_origin(api_call)
        if api_call.origin == 'cron'
            "<i class='bi bi-clock gd-admin-index-icon-margin' title='Cron'></i> ".html_safe
        else
            "<i class='bi bi-person-fill gd-admin-index-icon-margin' title='Usuario'></i> ".html_safe
        end
    end
end
