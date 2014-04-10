$(document).bind 'watch_test_sessions.load', (e, obj) =>
  session_id = window.session_id

  $('.show-status').on
    'click': (x) ->
      info_area = $(x.currentTarget).closest('tr').next('.student-test-status')
      info_area.show()
    'ajax:success': (x, d, s) ->
      $.modal("<div>#{d}</div>",
        overlayClose: true,
        closeHTML: "<a href='#' title='закрыть' class='modal-close'>закрыть это окно</a>",
      )
    'ajax:error': (x) ->
      info_area = $(x.currentTarget).closest('tr').next('.student-test-status')
      info_area.html('Не удалось загрузить информацию для данного студента. Возможно данный студент ещё не проходил тестирование')

  $('.generate-report-btn').on
    'ajax:success': (x, d, s, e) ->
      alertify.success "Отчет был успешно сохранен либо обновлен"
      link_element = $('#download-report-link')
      dl_link = Routes.download_report_path(id: d._id)
      link_element.attr('href', dl_link)
      link_element.text('Сохранить последнюю версию отчета на диск')
      link_element.show('normal')
    'ajax:error': (x) ->
      alertify.error "Произошла ошибка во время сохранения отчета, обратитесь к администратору системы"

  $('#only_active').change ->
    state = $(@).is(':checked')
    $('tr.inactive').toggle(!state)

  update_ui = () =>
    $.get Routes.session_status_path(session_id), (data) ->
      for e in data
        stud_elem = $("#student-#{e.student_id}")
        stud_elem.removeClass('inactive').show('normal')
        status_elem = stud_elem.children('.status')
        status_elem.parent('tr').removeClass().addClass(e.status)
        status_elem.html "#{e.answered_count}/#{e.total_count}"
        formatted_time = moment().startOf('day').seconds(e.remains_in_sec)
        # test session state
        state = switch e.status
          when 'completed' then 'Завершен'
          when 'out_of_time' then 'Завершен (лимит времени)'
          when 'active' then 'В процессе'
        stud_elem.children('.state').html state
        stud_elem.children('.remains').html formatted_time.format('HH:mm:ss')
        stud_elem.children('.in_percent').html "#{e.in_percent}%"
        stud_elem.children('.answered_percent').html "#{e.answered_percent}%"
  update_ui()
  setInterval (()-> update_ui()), 5000

  # when "update now" button clicked
  $('#update-information').on 'click', () ->
    update_ui()
    alertify.success "Информация была обновлена"