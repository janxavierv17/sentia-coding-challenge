module ApplicationHelper
  SORT_ICONS = {
    up: "M14.707 12.707a1 1 0 01-1.414 0L10 9.414l-3.293 3.293a1 1 0 01-1.414-1.414l4-4a1 1 0 011.414 0l4 4a1 1 0 010 1.414z",
    down: "M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z"
  }.freeze

  def sort_with_arrow(column, title)
    current_column = params[:sort] || "first_name"
    current_direction = params[:direction] || "asc"
    is_active = current_column == column
    next_direction = is_active && current_direction == "asc" ? "desc" : "asc"

    link_to(people_path(sort: column, direction: next_direction, search: params[:search]),
            data: { turbo_frame: "people_table" },
            class: "group inline-flex items-center gap-2 #{active_text_class(is_active)} transition-colors duration-200") do
      concat title
      concat direction_arrow(current_direction) if is_active
    end
  end

  private

  def active_text_class(is_active)
    is_active ? "text-white" : "text-sentia-gray-400 group-hover:text-white"
  end

  def direction_arrow(direction)
    icon_path = direction == "asc" ? SORT_ICONS[:up] : SORT_ICONS[:down]
    svg_icon(icon_path, "text-sentia-green")
  end

  def svg_icon(d_path, extra_classes)
    content_tag(:div, class: "flex flex-col ml-1") do
      content_tag(:svg, class: "w-2.5 h-2.5 #{extra_classes}", fill: "currentColor", viewBox: "0 0 20 20") do
        content_tag(:path, nil, fill_rule: "evenodd", d: d_path, clip_rule: "evenodd")
      end
    end
  end
end
