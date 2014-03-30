# test_sessions -> start
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
    # Если сообщение 421 - выйди из теста
    if d.status == 421
      window.location.href = Routes.results_path()


# test_sessions -> watch
$(document).bind 'watch_test_sessions.load', (e, obj) =>
  session_id = window.session_id
  $('.show-status').on
    
    'click': (x) ->
      info_area = $(x.currentTarget).closest('tr').next('.student-test-status')
      info_area.show()
    'ajax:success': (x, d, s) ->
      info_area = $(x.currentTarget).closest('tr').next('.student-test-status')
      info_area.html(d)
    'ajax:error': (x) ->
      info_area = $(x.currentTarget).closest('tr').next('.student-test-status')
      info_area.html('Не удалось загрузить информацию для данного студента. Возможно данный студент ещё не проходил тестирование')

  update_ui = () =>
    $.get Routes.session_status_path(session_id), (data) ->
      for e in data
        qs = e.question_statuses
        stud_elem = $("#student-#{e.student_id}")
        answered = qs.count((q) -> q.is_answered)
        status_elem = stud_elem.children('.status')
        status_elem.parent('tr').removeClass().addClass(e.status)
        status_elem.html "#{answered}/#{qs.length}"
        formatted_time = moment().startOf('day').seconds(e.remains_in_sec)
        state = switch e.status
          when 'completed' then 'Завершен'
          when 'out_of_time' then 'Завершен (по времени)'
          when 'active' then 'В процессе'
        stud_elem.children('.state').html state
        stud_elem.children('.remains').html formatted_time.format('HH:mm:ss')
        stud_elem.children('.in_percent').html "#{e.in_percent}%"
        stud_elem.children('.answered_percent').html "#{e.answered_percent}%"
  update_ui()
  setInterval (()-> update_ui()), 5000
  $('#update-information').on 'click', () -> update_ui()