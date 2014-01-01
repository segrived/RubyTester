#encoding: utf-8

class TestsController < ApplicationController
  before_filter { |c| c.check_permissions "manageTests" }
  before_filter :retrieve_top_tags

  respond_to :html, :json

  def index
    @tests = Test.unarchived
    # поиск по запросу
    if params.has_key? :search_request
      @tests = @tests.where(title: /#{params[:search_request]}/i)
    end
    # поиск по тегу
    if params.has_key? :tag
      @tests = @tests.tagged_with(params[:tag])
    end
    @tests = @tests.paginate(page: params[:page], per_page: 10)
  end

  def new
    @test = Test.new
  end
  
  def create
    @test = Test.new(params[:test])
    if @test.save then
      Rails.cache.delete('top-tags')
      redirect_to :tests and return
    end
    render :new
  end

  def edit
    @test = Test.includes(:questions).find(params[:id])
  end

  def update
    Rails.cache.delete('top-tags')
  end

  def tags
    @tags = Test.tags
    render :tags
  end

  def add_tag
    @test = Test.find(params[:id])
    @test.tags_array.push(params[:tag])
    @test.tags_array.uniq! # only unique tags
    if @test.save
      Rails.cache.delete('top-tags')
      render json: @test, status: 200
    else
      render nothing: true, status: 422
    end
  end

  def remove_tag
    @test = Test.find(params[:id])
    @test.tags_array.delete(params[:tag])
    if @test.save
      Rails.cache.delete('top-tags')
      render nothing: true, status: 200
    else
      render nothing: true, status: 422
    end
  end

  def archive
    @test = Test.find(params[:id])
    @test.update_attributes({is_archived: true})
    redirect_to :back
  end

  def destroy
    @test = Test.find(params[:id]).destroy
    Rails.cache.delete('top-tags')
    redirect_to :tests
  end

  private

  def retrieve_top_tags
    @top_tags = Rails.cache.fetch 'top-tags' do
      Test.tags_with_weight.sort_by { |x| -x.last }.take(20)
    end
  end
end