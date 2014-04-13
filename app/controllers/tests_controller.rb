#encoding: utf-8

class TestsController < ApplicationController
  before_filter -> c { c.check_permissions "manageTests" },
    only: [:new, :create, :edit, :update, :archive, :stats, :destroy]
  before_filter :retrieve_top_tags
  after_filter :clear_tags_cache, only: [:create, :update, :destroy]
  before_filter :fetch_test, only: [:edit, :archive, :destroy, :stats]

  respond_to :html, :json

  # GET /tests
  def index
    # По умолчанию отображаются только неархивные записи
    @tests = Test.unarchived
    # поиск по запросу
    if params.has_key? :search_request
      @tests = @tests.where(title: /#{params[:search_request]}/i)
    end
    # поиск по тегу
    if params.has_key? :tag
      @tests = @tests.in(tags: params[:tag])
    end
    @tests = @tests.paginate(page: params[:page], per_page: 10)
  end

  # GET /tests/new
  def new
    @test = Test.new
  end
  
  # POST /tests
  def create
    @test = Test.new(params[:test])
    if @test.save then
      redirect_to :tests
    else
      render :new
    end
  end

  # GET /tests/1/edit
  def edit
  end

  # PUT /tests/1
  def update
  end

  # POST /tests/1/archive
  def archive
    @test.update_attributes({is_archived: params[:set_state]})
    redirect_to :tests, notice: "Состояние теста «#{@test.title}» было изменено"
  end

  # GET /tests/archived
  def archived
    @tests = Test.archived
  end

  # DELETE /tests/1
  def destroy
    @test.destroy and redirect_to :tests
  end

  # GET /tests/tags
  def tags
    @tags = Test.distinct(:tags).sort
    render :tags
  end

  def stats
    @test_sessions = @test.test_sessions
    render partial: 'stats'
  end

  private

  def fetch_test
    @test = Test.find(params[:id])
  end

  def clear_tags_cache
    Rails.cache.delete('top-tags')
  end

  def retrieve_top_tags
    @top_tags = Rails.cache.fetch 'top-tags' do
      Test.top_tags(20)
    end
  end
end