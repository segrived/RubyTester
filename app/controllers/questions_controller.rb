# encoding: utf-8

class QuestionsController < ApplicationController

  def update
    question = Question.find(params[:id])
    question.update_attributes(params[:question])
  end

end