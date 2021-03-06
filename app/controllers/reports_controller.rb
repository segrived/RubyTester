# encoding: utf-8

class ReportsController < ApplicationController
  def index
    @reports = Report.all
  end

  def download
    report = Report.find(params[:id])
    fn = File.join(Rails.root, "public", "reports", "#{report.type}", report.file_name)
    send_file(fn, filename: report.title.gsub('.', '-'), type: 'application/pdf')
  end

  def delete
    report = Report.find(params[:id])
    fn = File.join(Rails.root, "public", "reports", "#{report.type}", report.file_name)
    File.delete(fn)
    report.destroy
    redirect_to :back, notice: 'Отчет был успешно удален'
  end
end