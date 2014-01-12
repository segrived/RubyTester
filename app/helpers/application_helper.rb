module ApplicationHelper

  def error_box(object)
    (render partial: '/shared/errors', object: object).html_safe
  end

  def active_session
    TestStudentAssignment.find_by_key(cookies[:test_key])
  end

  def has_uncompleted_session?
    key = cookies[:test_key]
    return false unless key
    assignment = TestStudentAssignment.find_by_key(key)
    return false unless assignment
    !assignment.completed?
  end

end


class ActionView::Helpers::FormBuilder
  def errors
    if @object.errors.any?
      l = { errors: @object.errors }
      @template.render partial: 'shared/errors', locals: l
    end
  end
end