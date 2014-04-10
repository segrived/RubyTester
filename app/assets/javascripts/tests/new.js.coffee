$(document).bind 'new_tests.load', (e, obj) =>
  $('#tag-list span.tag').click ->
    tag_element = $(@)
    current_tags = $('#test_tags').val()
    app = if current_tags.length == 0 || current_tags.match /,\s*$/
      tag_element.text()
    else ", #{tag_element.text()}"
    $('#test_tags').val("#{current_tags}#{app}")
    tag_element.remove()