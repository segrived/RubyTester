#encoding: utf-8

class TestSessionsController < ApplicationController

  before_filter -> c { c.check_permissions "useTests" },
    only: [:new, :create, :destroy, :watch, :report, :status]
  before_filter :fetch_test, only: [:index, :new, :create, :destroy_inactive]
  before_filter :fetch_session,
    only: [:destroy, :assign_student, :check_question, :watch, :report, :full_report]
  before_filter :check_assignment_is_active, only: [:start, :results]
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
    @test_session = @test.test_sessions.build(params[:test_session])
    if @test_session.save then
      redirect_to session_watch_path(@test_session)
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
    x = TestStudentAssignment.where(test_session_id: params[:id])
    render json: x.to_json(methods: [:completed?, :in_percent])
  end

  def register
    if cookies[:test_key].present?
      if TestStudentAssignment.where(private_key: cookies[:test_key]).exists?
        redirect_to :go
      else
        cookies.delete(:test_key)
        redirect_to session_register_path(params[:id])
      end
    else
      @session = TestSession.find(params[:id])
    end
  end

  def assign_student
    assignment = TestStudentAssignment.new(test_session_id: @session.id, student_id: params[:student_id])
    qs = Question.get_random_ids(@session.test, @session.questions_count).to_a.map { |question|
      QuestionStatus.new(question: question, is_answered: false)
    }.to_a
    assignment.question_statuses = qs
    assignment.save
    cookies[:test_key] = assignment.private_key
    redirect_to :go
  end

  def start
    @a = TestStudentAssignment.where(private_key: cookies[:test_key]).first
    if @a.completed? || !@a.active?
      redirect_to :results and return
    end
    @question_statuses = @a.question_statuses.unanswered
    render :test_page
  end

  def check_question
    @question = Question.find(params[:question_id])
    answer = params[:answer]
    assignment = TestStudentAssignment.find_by_key(cookies[:test_key])
    status = assignment.question_statuses.find(params[:question_status_id])
    # Если на вопрос уже дан ответ
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
      if (answer - @question.answer).count > 0
        result = 0.0
      else
        valid_variants = (answer & @question.answer).count
        result = valid_variants.to_f / @question.answer.count.to_f
      end
    end
    # Обновление статуса вопроса
    status.update_attributes({
      is_answered: true,
      correctness_level: result,
      answered_at: DateTime.now
    })
    response = { completed: assignment.completed? }
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
    render json: @session.to_json(include: [:test_student_assignments, :test, :group])
  end

  def report
    @assignment = @session.test_student_assignments.where(student_id: params[:student_id]).first
    unless @assignment
      redirect_to :back and return
    end
    @question_ids = @assignment.question_statuses.map(&:question_id)
    @questions = Question.any_in(id: @question_ids).only(:text).to_a
    respond_to do |format|
      format.html
      format.pdf { render layout: false }
    end
  end

  def results
    @assignment = TestStudentAssignment.find_by_key(cookies[:test_key])
    unless @assignment.completed?
      redirect_to :go and return
    end
  end

  def end
    cookies.delete :test_key
    redirect_to :root
  end

  private

  def check_private_key
  end

  def check_assignment_is_active
    unless TestStudentAssignment.find_by_key(cookies[:test_key])
      redirect_to :root
    end
  end

  def fetch_test
    @test = Test.find(params[:test_id])
  end

  def fetch_session
    @session = TestSession.find(params[:id])
  end

end