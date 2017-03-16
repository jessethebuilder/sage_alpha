module ApplicationHelper
  def page_heading(title)
    render partial: 'helper_partials/page_heading', locals: {title: title}
  end

  def side_nav(*options)
    render partial: "helper_partials/side_nav", locals: {options: options}
  end
end
