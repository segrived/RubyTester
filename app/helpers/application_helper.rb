# encoding: utf-8

module ApplicationHelper

  def error_box(object)
    (render partial: '/shared/errors', object: object).html_safe
  end

  def active_session
    TestAttempt.find_by_key(cookies[:test_key])
  end

  def has_uncompleted_session?
    key = cookies[:test_key]
    return false unless key
    attempt = TestAttempt.find_by_key(key)
    return false unless attempt
    !attempt.completed?
  end

  def tags_list(test)
    if test.tags.any?
      test.tags.map {|tag| link_to tag, test_tags_path(tag) }.join(', ').html_safe
    else
      "отсутствуют"
    end
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