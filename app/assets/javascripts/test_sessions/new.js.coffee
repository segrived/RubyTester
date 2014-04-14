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
  $('#test_session_session_length').change ->
    if @value == 'user_defined'
      alertify.prompt "Введите время в минутах", (e, str)->
        if e
          $('#user_defined_field').remove()
          element = $("<option></option>").attr({
            value: str, id: "user_defined_field"
          }).text("* #{str} минут")
          $('#test_session_session_length option:last').before(element)
          $('#test_session_session_length').val(str)