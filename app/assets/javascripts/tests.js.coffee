# tests -> *
$(document).bind 'tests.load', (e, obj) =>

# tests -> index
$(document).bind 'index_tests.load', (e,obj) =>
  $('.show-active-sessions').click ->
    $(@).parents('.test-item').find('.test-session-list').toggle('fast')

# tests -> new
$(document).bind 'new_tests.load', (e, obj) =>
  $('#tag-list span.tag').click ->
    e = $(@)
    current_tags = $('#test_tags').val()
    app = if current_tags.length == 0 || current_tags.match /,\s*$/
      e.text()
    else ", #{e.text()}"
    $('#test_tags').val("#{current_tags}#{app}")
    e.remove()

# tests -> edit
$(document).bind 'edit_tests.load', (e, obj) =>
  $('.remove-test-tag').on 
    'ajax:success': -> $(this).parent('.test-tag').remove()
    'ajax:error':   -> alert('Не удалось удалить тег')

  $('#test-options-link').click ->
    $('#test-options').slideToggle('fast')

  $('#add-tag-link').click -> $('#add-tag-form').show()