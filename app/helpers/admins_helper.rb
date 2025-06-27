module AdminsHelper
  # This method generates a table header for the given resource for the index page.
  def columns_for(resource)
    case resource
    when :participants
      [
        { header: icon('text') + ' Número', value: ->(p) { p.contact } },
        { header: icon('text') + ' CI', value: ->(p) { p.document || 'N/D' } },
        { header: icon('text') + ' Departamento', value: ->(p) { p.state&.name || 'Sin departamento' } },
        { header: icon('calendar-alt') + ' Fecha', value: ->(p) { py_date(p.updated_at) } }
      ]
    when :participations
      [
        { header: icon('text') + ' Número', value: ->(pp) { pp.participant.contact } },
        { header: icon('text') + ' CI', value: ->(pp) { pp.participant.document || 'N/D' } },
        { header: icon('text') + ' Departamento', value: ->(pp) { pp.participant.state&.name || 'Sin departamento' } }
      ]
    when :winners
      [
        { header: icon('text') + ' Número', value: ->(w) { w.participant.contact } },
        { header: icon('text') + ' CI', value: lambda { |w|
                                                 number_with_delimiter(w.participant.document, delimiter: '.') || 'N/D'
                                               } },
        { header: icon('pin') + ' Departamento', value: ->(w) { w.participant.state&.name } },
        { header: icon('text') + ' Participaciones', value: ->(w) { w.participant.participations_count || 'N/D' } },
        { header: icon('barcode') + ' Lote Ganador', value: lambda { |w|
                                                              w.participant.participations.order(created_at: :desc).first&.code_str || 'N/D'
                                                            } },
        { header: icon('trophy') + ' Premio', value: ->(w) { w.participant.winner&.prize&.name || 'N/D' } }

      ]
    when :states
      [
        { header: icon('text') + ' ID', value: ->(s) { s.id } },
        { header: icon('text') + ' Nombre', value: ->(s) { s.name } },
        { header: icon('text') + ' Activo?', value: ->(s) { generic_active(s.active) } }
      ]
    when :prizes
      [
        { header: icon('text') + ' ID', value: ->(p) { p.id } },
        { header: icon('text') + ' Nombre', value: ->(p) { p.name } },
        { header: icon('text') + ' Frecuencia', value: ->(p) { p.step } },
        { header: icon('text') + ' Cantidad', value: ->(p) { p.quantity } },
        { header: icon('text') + ' Stock', value: ->(p) { p.stock } },
        { header: icon('text') + ' Sorteados', value: ->(p) { p.winners.count } },
        { header: icon('status') + ' Activo', value: ->(p) { generic_active(p.active) } }
      ]

    else
      raise ArgumentError, "No hay columnas definidas para: #{resource}.
      Revisar el helper o la vista.
      #{caller.first}"
    end
  end

  # This method generates a table row for the given resource for the index page.
  def record_path_for(resource)
    case resource
    when :participants
      ->(p) { participant_path(p) }
    when :participations
      ->(pp) { participation_path(pp) }
    when :winners
      ->(w) { participant_path(w.participant) }
    when :states
      ->(s) { state_path(s) }
    else
      raise ArgumentError, "No hay record path definido para: #{resource}.
      Revisar el helper o el index.
      Está el argumento en plural?
      #{caller.first}"
    end
  end

  def py_date(datetime)
    datetime.strftime('%d/%m/%Y %H:%M:%S')
  rescue StandardError
    ''
  end

  def span_status(status, options = %w[Activo Inactivo])
    content_tag :span, status ? options.first : options.last,
                class: "badge badge-sm #{status ? 'bg-success' : 'bg-secondary'}"
  end

  def alert_type(type)
    case type
    when 'success', 'notice' then 'success'
    when 'alert', 'error' then 'danger'
    when 'warning' then 'warning'
    else 'info'
    end
  end
end
