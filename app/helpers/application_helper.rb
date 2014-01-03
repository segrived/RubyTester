module ApplicationHelper

  def error_box(object)
    (render partial: '/shared/errors', object: object).html_safe
  end

  # def onject

end


class ActionView::Helpers::FormBuilder
  def errors
    if @object.errors.any?
      l = { errors: @object.errors }
      @template.render partial: 'shared/errors', locals: l
    end
  end
end