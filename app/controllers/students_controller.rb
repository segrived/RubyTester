#encoding: utf-8

class StudentsController < ApplicationController

  before_filter -> c { c.check_permissions "manageStudents" }

  def create
    @group = Group.find(params[:group_id])
    @student = @group.students.build(params[:student])
    @student.save
    redirect_to group_path(@group)
  end

  def destroy
    @student = Student.find(params[:id])
    @student.destroy
    redirect_to group_path(params[:group_id])
  end
end