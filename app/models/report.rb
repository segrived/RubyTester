# encoding: utf-8

class Report
  include Mongoid::Document

  field :file_name, type: String
  field :type, type: Symbol
  field :title, type: String
  field :filesize, type: Integer

  index({ file_name: 1 }, { unique: true })
  index({ title: 1 })
end