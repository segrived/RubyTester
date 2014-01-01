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
    if d.is_valid?
      if d.is_valid
        alertify.success("Дан верный ответ")
      else
        alertify.error("Дан неверный ответ")
    if d.completed
      window.location.href = Routes.results_path()
      return
    answered = parseInt($('#answered-count').html(), 10)
    $('#answered-count').html(answered+1)
    $(@).parent('.answer-area').hide 'normal'


# test_sessions -> watch
$(document).bind 'watch_test_sessions.load', (e, obj) =>
  update_ui = (session_id) =>
    $.get "/sessions/#{session_id}/status", (data) ->
      for e in data
        student_status = $("#student-#{e.student_id} .status")
        if e['completed?'] == true
          student_status.parent('tr').removeClass().addClass('completed')
        else
          student_status.parent('tr').removeClass().addClass('active')
        valid_answers = (_.filter e.question_statuses, (qs) -> qs.is_valid_answer).length
        answered = (_.filter e.question_statuses, (qs) -> qs.is_answered).length
        percent = if answered == 0 then 0 else Math.round((valid_answers / answered) * 100)
        student_status.html("#{percent}% (#{valid_answers} из #{answered})")
  session_id = $('#update-information').data('session-id')
  update_ui session_id

  setInterval (()-> update_ui session_id), 5000

  $('#update-information').on 'click', () ->
    session_id = $(@).data('session-id')
    update_ui session_id