#encoding: utf-8

class GroupsController < ApplicationController

  before_filter -> c { c.check_permissions "manageStudents" }

  def index
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(params[:group])
    if @group.save then
      redirect_to group_path(@group)
    else
      render :new
    end
  end

  def show
    @group = Group.find(params[:id])
  end

  def destroy
    Group.find(params[:id]).destroy
    redirect_to :groups
  end
end