$(document).bind 'new_test_sessions.load', (e, obj) =>
  $('#generate_code').click -> 
    # from 100000 to 999999 (6-digits number)
    code = (Math.floor Math.random() * 899999) + 100000
    $('#test_session_secret_code').val(code)
  $('#add_group_field').click ->
    field = $('.test-session-group-field:first').clone()
    $('#test-session-group-fields').append(field)
  $(document).on 'click', '.remove-group-select', ->
    fields = $('.test-session-group-field').size()
    if fields > 1
      $(@).parent('.test-session-group-field').remove()
    else
      alertify.error "Нельзя удалить последнюю группу"