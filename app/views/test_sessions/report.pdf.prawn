prawn_document() do |pdf|
  pdf.font_families.update("DejaVuSans" => {normal: "#{Rails.root}/app/assets/fonts/DejaVuSans.ttf" })
  pdf.font "DejaVuSans"
  pdf.text "Статус прохождения теста", font: "sans", align: :center, size: 18
  pdf.stroke_horizontal_rule
  pdf.move_down 10
  pdf.font_size 10 do
    pdf.text "Студент: #{@assignment.student.fullname}"
    pdf.text "Тест: #{@assignment.test_session.test.title}"
    pdf.text "Ключ: #{@assignment.private_key}"
    pdf.text "Статус прохождения: #{@assignment.completed? ? 'завершен' : 'не завершен'}", align: :left
    pdf.text "Статус теста: #{@assignment.active? ? 'активен' : 'неактивен'}", align: :left
  end
  pdf.move_down 25
  pdf.text "Общая статистика прохождения", align: :center, size: 16
  pdf.stroke_horizontal_rule
  pdf.move_down 10
  pdf.text "Правильность ответов: #{@assignment.valid_percent}%", color: "#00ff00"
  pdf.move_down 25
  pdf.text "Статистика по вопросам", align: :center, size: 16
  pdf.stroke_horizontal_rule
  pdf.move_down 10
  pdf.font_size 12 do
    @assignment.question_statuses.each do |qs|
      text = @questions.select {|q| q.id == qs.question_id}.first.text
      pdf.text "<color rgb='0000ff'>Вопрос</color>: #{text}", inline_format: true
      if qs.is_answered
        if qs.is_valid_answer
          pdf.text "Был дан верный ответ", color: '008800'
        else
          pdf.text "Был дан неверный ответ", color: '880000'
        end
      end
      pdf.move_down 10
    end
  end

  pdf.repeat :all do
    pdf.bounding_box [pdf.bounds.left, pdf.bounds.bottom + 25], width: pdf.bounds.width do
      pdf.stroke_color 'aaaaaa'
      pdf.stroke_horizontal_rule
      pdf.move_down 5
      pdf.text "RubyTester #{Configuration.app_version}", size: 9, align: :right
    end
  end

end