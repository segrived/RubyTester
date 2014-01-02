#encoding: utf-8

class StudentsController < ApplicationController

  before_filter -> c { c.check_permissions "manageStudents" }

  def new
    @student = Student.new
  end

  def create
    @group = Group.find(params[:group_id])
    @student = @group.students.build(params[:student])
    if @student.save
      redirect_to group_path(@group)
    else
      render :new
    end
  end

  def destroy
    Student.find(params[:id]).destroy
    redirect_to group_path(params[:group_id])
  end
end