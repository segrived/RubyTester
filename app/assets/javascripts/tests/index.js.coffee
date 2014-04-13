$(document).bind 'index_tests.load', (e,obj) =>
  $('.show-active-sessions').click ->
    $(@).parents('.test-item').find('.test-session-list').toggle('fast')
  $('.show-stats').on
    'ajax:success': (x, d, s, e) ->
      modal_window(d)