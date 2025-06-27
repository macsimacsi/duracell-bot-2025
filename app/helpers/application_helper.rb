module ApplicationHelper
  include Pagy::Frontend

  def py_date_and_time(datetime)
    datetime.strftime('%d/%m/%Y %H:%M:%S')
  rescue StandardError
    ''
  end

  def bs_icon(class_)
    tag.i class: class_
  end

  def icon(type_)
    "<i class='align-middle fas fa-fw fa-#{type_} gd-font-12'></i>".html_safe
  end

  def sortable(column, title = nul)
    title ||= column.titleize
    direction = column == params[:sort] && params[:direction] == 'asc' ? 'desc' : 'asc'

    if column == params[:sort]
      css = direction == 'asc' ? '<i class="align-middle me-2 fas fa-fw fa-long-arrow-alt-up"></i>' : '<i class="align-middle me-2 fas fa-fw fa-long-arrow-alt-down"></i>'
    else
      css = ''
    end

    # css = direction == 'asc' ? '<i class="align-middle me-2 fas fa-fw fa-long-arrow-alt-down"></i>' : '<i class="align-middle me-2 fas fa-fw fa-long-arrow-alt-up"></i>'

    link_to (title.html_safe + css.html_safe), sort: column, direction: direction
  end

  def is_active(current_path, path)
    current_path == path ? 'active' : ''
  end

  def generic_active(active)
    if active
      '<span class="badge badge-success-light"> <i class="mdi mdi-arrow-bottom-right"></i> Sí </span>'.html_safe
    else
      '<span class="badge badge-danger-light"> <i class="mdi mdi-arrow-bottom-right"></i> No </span>'.html_safe
    end
  end
end
