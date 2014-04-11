$(document).bind 'results_test_sessions.load', (e, obj) =>
  $('#show-stats-btn').click ->
    content = $('#stats-container').html()
    modal_window(content)