$(document).bind 'new_test_sessions.load', (e, obj) =>
  $('#generate_code').click -> 
    # from 100000 to 999999 (6-digits number)
    code = (Math.floor Math.random() * 899999) + 100000
    $('#test_session_secret_code').val(code)