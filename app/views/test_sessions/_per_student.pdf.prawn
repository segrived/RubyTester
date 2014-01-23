attempt.question_statuses.each do |qs|
  text = qs.question.text
  pdf.text "<color rgb='0000ff'>Вопрос</color>: #{text}", inline_format: true
  if qs.is_answered
    if qs.correctness_level == 1.0
      pdf.text "Был дан верный ответ", color: '008800'
    elsif qs.correctness_level == 0.0
      pdf.text "Был дан неверный ответ", color: '880000'
    else
      pdf.text "Был дан частично верный ответ", color: 'B16A0A'
    end
  else
    pdf.text "На момент генерации отчета этот вопрос остался неотвеченным", color: '888888'
  end
  pdf.move_down 10
end