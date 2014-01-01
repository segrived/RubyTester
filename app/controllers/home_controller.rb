# encoding: utf-8

class HomeController < ApplicationController
  def index
    @active_sessions = TestSession.active
  end
end