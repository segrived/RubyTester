#encoding: utf-8

class Admin::MaintenanceController < Admin::AdminController
  def index
    render 'index'
  end

  def rebuild_tag_index
    Test.save_tags_index!
    redirect_to :back, notice: 'Индекс тегов был успешно перестоен'
  end
end