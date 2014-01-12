# encoding: utf-8

class QuestionsController < ApplicationController

  def update
    render json: params
  end

end