#encoding: utf-8

class GroupsController < ApplicationController

  before_filter -> c { c.check_permissions "manageStudents" }

  def index
    @groups = Group.all
    @new_group = Group.new
  end

  def create
    @group = Group.new(params[:group])
    if @group.save then
      render text: @group, status: 200
    else
      render text: @group.errors.full_messages, status: 422
    end
  end

  def show
    @group = Group.find(params[:id])
    @students = @group.students
    @student = Student.new
  end
end