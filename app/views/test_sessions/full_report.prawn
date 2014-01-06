prawn_document() do |pdf|
  pdf.font_families.update("DejaVuSans" => {normal: "#{Rails.root}/app/assets/fonts/DejaVuSans.ttf" })
  pdf.font "DejaVuSans"
  pdf.text "Полный отчет по прохождению", font: "sans", align: :center, size: 18
  pdf.stroke_horizontal_rule
  pdf.move_down 10
  pdf.text "Список студентов, проходивших тест", align: :center, size: 16
  @session.test_student_assignments.each do |a|
    pdf.text "* <link anchor='#{a.id}'>#{a.student.fullname}</link>", inline_format: true
  end
  @session.test_student_assignments.each do |a|
    pdf.start_new_page
    pdf.add_dest(a.id, pdf.dest_fit)
    pdf.text a.student.fullname
    pdf.stroke_horizontal_rule
    pdf.move_down 10
    render 'per_student', pdf: pdf, assignment: a
  end
end