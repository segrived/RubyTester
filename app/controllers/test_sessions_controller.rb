#encoding: utf-8

class TestSessionsController < ApplicationController

  before_filter -> c { c.check_permissions "useTests" },
    only: [:new, :create, :destroy, :watch, :report, :status]
  before_filter :fetch_test, only: [:index, :new, :create, :destroy_inactive]
  before_filter :fetch_session, only: [
    :destroy, :assign_student, :check_question,
    :watch, :report, :questions_status, :full_report, :status]
  before_filter :check_attempt_is_active, only: [:start, :results]
  before_filter :check_private_key

  # GET /tests/1/sessions
  def index
    @sessions = @test.test_sessions
  end

  # GET /tests/1/sessions/new
  def new
    @test_session = TestSession.new
  end

  # POST /tests/1/sessions
  def create
    @session = @test.test_sessions.build(params[:test_session])
    @session.user = logged_user.id
    if @session.save then
      redirect_to session_watch_path(@session)
    else
      render :new
    end
  end

  # DELETE /tests/1/sessions/inactive
  def destroy_inactive
    @test.test_sessions.inactive.destroy_all
    redirect_to :back, notice: 'Все неактивные сессии были удалены'
  end

  # DELETE /tests/1/sessions/2
  def destroy
    @session.destroy
    redirect_to :tests
  end

  # GET /sessions/1/status
  def status     
    render json: @session.test_attempts
  end

  def register
    if cookies[:test_key].present?
      if TestAttempt.where(private_key: cookies[:test_key]).exists?
        redirect_to :start
      else
        cookies.delete(:test_key)
        redirect_to session_register_path(params[:id])
      end
    else
      @session = TestSession.find(params[:id])
    end
  end

  def assign_student
    attempt = TestAttempt.new(test_session_id: @session.id, student_id: params[:student_id])
    qs = Question.get_random_ids(@session.test, @session.questions_count).to_a.map { |question|
      QuestionStatus.new(question: question)
    }.to_a
    attempt.question_statuses = qs
    attempt.save
    cookies[:test_key] = attempt.private_key
    redirect_to :start
  end

  def start
    @a = TestAttempt.where(private_key: cookies[:test_key]).first
    if @a.completed? || !@a.active?
      redirect_to :results and return
    end
    @question_statuses = @a.question_statuses.includes(:question).unanswered
    render :test_page
  end

  def check_question
    @question = Question.find(params[:question_id])
    answer = params[:answer]
    attempt = TestAttempt.find_by_key(cookies[:test_key])
    status = attempt.question_statuses.find(params[:question_status_id])
    # Если на вопрос уже дан ответ
    if attempt.completed?
      render json: {error: "На все вопросы уже были даны ответы"}, status: 421
      return
    end
    if status.is_answered
      render json: {error: "Да данный вопрос уже дан ответ"}, status: 420
      return
    end
    # TODO: вынести в более удачное место (!!!)
    if @question.type == 'simple'
      is_valid = /\A#{@question.answers}\Z/i.nil?
      result = (answer =~ is_valid) ? 0.0 : 1.0
    elsif @question.type == 'onechoice'
      result = @question.answer == answer ? 1.0 : 0.0
    elsif @question.type == 'multiplechoice'
      answer = (answer || []).uniq
      if attempt.test_session.use_partially_correct_answers
        if (answer - @question.answer).count > 0
          result = 0.0
        else
          valid_variants = (answer & @question.answer).count
          result = valid_variants.to_f / @question.answer.count.to_f
        end
      else
        result = (answer.sort == @question.answer.sort) ? 1.0 : 0.0
      end
    end
    # Обновление статуса вопроса
    status.update_attributes({
      is_answered: true,
      correctness_level: result,
      answered_at: DateTime.now
    })
    response = { completed: attempt.completed? }
    if @session.report_correct_status
      response[:correctness_level] = case result
        when 0.0 then :incorrect
        when 1.0 then :correct
        else :partially_correct
      end
    end
    render json: response
  end

  def watch
  end

  def full_report
    @questions = @session.test.questions.to_a
    @students = @session.group.students.to_a
    render pdf: 'full_report'
  end

  def questions_status
    @attempt = @session.test_attempts.where(student_id: params[:student_id]).first
    @questions = @attempt.question_statuses.includes(:question)
    render partial: 'questions_status'
  end

  def report
    @attempt = @session.test_attempts.where(student_id: params[:student_id]).first
    unless @attempt
      redirect_to :back and return
    end
    @questions = @attempt.question_statuses.includes(:question)
    respond_to do |format|
      format.html
      format.pdf { render layout: false }
    end
  end

  def results
    @attempt = TestAttempt.find_by_key(cookies[:test_key])
    if @attempt.active? && !@attempt.completed?
      redirect_to :start and return
    end
  end

  def end
    cookies.delete :test_key
    redirect_to :root
  end

  private

  def check_private_key
  end

  def check_attempt_is_active
    if cookies[:test_key].nil? || !TestAttempt.find_by_key(cookies[:test_key])
      redirect_to :root and return
    end
  end

  def fetch_test
    @test = Test.find(params[:test_id])
  end

  def fetch_session
    @session = TestSession.find(params[:id])
  end

end