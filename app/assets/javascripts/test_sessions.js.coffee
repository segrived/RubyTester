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
    progress_remains = r_sec / total_seconds * 100
    pb_progress.css('width', "#{progress_remains}%")
    pb_text.html remains.format('HH:mm:ss')

  update_countdown() # init countdown state
  setInterval(update_countdown, 1000)

  $('.answer-form').on 'ajax:success': (e, d, s, x) -> 
    if d.correctness_level?
      if d.correctness_level == 'correct'
        alertify.success "Дан верный ответ"
      else if d.correctness_level == 'incorrect'
        alertify.error "Дан неверный ответ"
      else if d.correctness_level == 'partially_correct'
        alertify.success "Дан частично верный ответ"
      else
        alertify.error "Состояние ответа неизвестно"
    if d.completed
      window.location.href = Routes.results_path()
      return
    answered = parseInt($('#answered-count').html(), 10)
    $('#answered-count').html(answered+1)
    $(@).parent('.answer-area').hide 'normal'


# test_sessions -> watch
$(document).bind 'watch_test_sessions.load', (e, obj) =>
  session_id = window.session_id

  update_ui = () =>
    $.get Routes.session_status_path(session_id), (data) ->
      for e in data
        qs = e.question_statuses
        element_class = if e['completed?'] then 'completed' else 'active'
        answered = (_.filter qs, (q) -> q.is_answered).length
        status_elem = $("#student-#{e.student_id} .status")
        status_elem.parent('tr').removeClass().addClass(e.status)
        status_elem.html "#{answered}/#{qs.length}"
        $("#student-#{e.student_id} .remains").html "#{e.remains_in_sec} сек."
        $("#student-#{e.student_id} .in_percent").html "#{e.in_percent}%"
        $("#student-#{e.student_id} .answered_percent").html("#{e.answered_percent}%")
  update_ui()
  setInterval (()-> update_ui()), 5000
  $('#update-information').on 'click', () -> update_ui()