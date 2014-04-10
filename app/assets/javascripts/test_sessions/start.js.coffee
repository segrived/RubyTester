$(document).bind 'start_test_sessions.load', (e, obj) =>
  remains_init = $('#remains-time-text').data('remains-sec')
  total_seconds = $('#total-time').data('total-sec')
  end_time = moment().add('s', remains_init)
  pb_progress = $("#progress-bar #remains-progress")
  pb_text = $('#progress-bar #remains-time-text-inner')
  update_countdown = () ->
    # время вышло
    if moment() > end_time
      window.location.href = Routes.results_path()
      return
    r_sec = moment(end_time).diff(moment(), 'seconds')
    remains = moment().startOf('day').seconds(r_sec)
    progress_remains = r_sec / total_seconds
    pb_progress.css('width', "#{progress_remains * 100}%")
    pb_text.html remains.format('HH:mm:ss')

  update_countdown() # init countdown state
  setInterval(update_countdown, 1000)

  $('.answer-form').on 'ajax:success': (e, d, s, x) -> 
    if d.correctness_level?
      status = switch d.correctness_level
        when 'correct' then ['success', 'Дан верный ответ']
        when 'incorrect' then ['error', 'Дан неверный ответ']
        when 'partially_correct' then ['success', 'Дан частично верный ответ']
        else ['error', 'Состояние ответа неизвестно']
      if status.first() == 'success'
        alertify.success status.last()
      else
        alertify.error status.last()
    if d.completed
      window.location.href = Routes.results_path()
      return
    answered = parseInt($('#answered-count').html(), 10)
    $('#answered-count').html(answered+1)
    $(@).parent('.answer-area').hide 'normal'
  $('.answer-form').on 'ajax:error': (e, d, s, x) ->
    alertify.error(d.responseJSON.error)
    # Если код сообщение 420 - сообщение нужно скрыть
    if d.status == 420
      $(@).parent('.answer-area').hide 'normal'
    # Если код 421 - выйди из теста
    if d.status == 421
      window.location.href = Routes.results_path()