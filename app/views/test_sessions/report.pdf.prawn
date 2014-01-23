prawn_document() do |pdf|
  pdf.font_families.update("DejaVuSans" => {normal: "#{Rails.root}/app/assets/fonts/DejaVuSans.ttf" })
  pdf.font "DejaVuSans"
  pdf.text "Статус прохождения теста", font: "sans", align: :center, size: 18
  pdf.stroke_horizontal_rule
  pdf.move_down 10
  pdf.font_size 10 do
    pdf.text "Студент: #{@attempt.student.fullname}"
    pdf.text "Группа: #{@attempt.test_session.group.name}"
    pdf.text "Тест: #{@attempt.test_session.test.title}"
    pdf.text "Ключ: #{@attempt.private_key}"
    pdf.text "Статус прохождения: #{@attempt.completed? ? 'завершен' : 'не завершен'}", align: :left
    pdf.text "Статус теста: #{@attempt.active? ? 'активен' : 'неактивен'}", align: :left
  end
  pdf.move_down 25
  pdf.text "Общая статистика прохождения", align: :center, size: 16
  pdf.stroke_horizontal_rule
  pdf.move_down 10
  pdf.text "Общая правильность ответов: #{@attempt.in_percent}%", color: "#00ff00"
  pdf.move_down 25
  pdf.text "Статистика по вопросам", align: :center, size: 16
  pdf.stroke_horizontal_rule
  pdf.move_down 10
  pdf.font_size 12 do
    render 'per_student', pdf: pdf, attempt: @attempt
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