# encoding: utf-8

class TestSessionReport < BaseReport

  attr_accessor :session
  
  def initialize(file_name, session)
    super(file_name)
    self.session = session
    @questions = @session.test.questions.to_a
    @attempts = @session.test_attempts.includes(:student)
  end

  protected

  def render_pdf
    @pdf.font "DejaVuSans"
    @pdf.text "Полный отчет по прохождению теста", align: :center, size: 20
    @pdf.stroke_horizontal_rule
    @pdf.move_down 10
    @pdf.text "Список студентов, проходивших тест", size: 14, color: '222222'
    @pdf.move_down 10
    @attempts.each do |a|
      item = "<link anchor='#{a.id}'>#{a.student.fullname} (#{a.student.group})</link>"
      bullet_item item, 1, inline_format: true, color: '555555'
    end
    render_per_student
  end

  private

  def render_per_student
    @attempts.each do |attempt|
      @pdf.start_new_page
      @pdf.add_dest(attempt.id, @pdf.dest_fit)
      @pdf.text attempt.student.fullname
      @pdf.stroke_horizontal_rule
      @pdf.move_down 10
      attempt.question_statuses.each do |question_status|
        render_question_statuses question_status
      end
    end
  end

  def render_question_statuses question_status
    text = question_status.question.text
    @pdf.text "<color rgb='0000ff'>Вопрос</color>: #{text}", inline_format: true
    if question_status.is_answered
      case question_status.correctness_level
      when 1.0 then pdf.text "Был дан верный ответ", color: '008800'
      when 0.0 then pdf.text "Был дан неверный ответ", color: '880000'
      else @pdf.text "Был дан частично верный ответ", color: 'B16A0A'
      end
    else
      @pdf.text "На момент генерации отчета этот вопрос остался неотвеченным", color: '888888'
    end
    @pdf.move_down 10
  end

end