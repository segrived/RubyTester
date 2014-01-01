class Admin::AdminController < ApplicationController

  before_filter { |c| c.check_permissions "admin" }

  def index
    render 'admin/index'
  end
end