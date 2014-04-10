# encoding: utf-8

class BaseReport
  attr_accessor :file_name
  attr_reader :pdf

  ROOT_REPORTS_PATH = Rails.root.join("public", "reports", "session")

  def initialize(file_name)
    self.file_name = file_name
    @pdf = Prawn::Document.new
    prepare_prawn()
  end

  def bullet_item(string, level = 1, options = {})
    @pdf.indent(15 * level) do
      @pdf.text("• #{string}", options)
    end
  end

  def prepare_prawn
    font_path = File.join(Rails.root, "app", "assets", "fonts", "DejaVuSans.ttf")
    @pdf.font_families.update("DejaVuSans" => {normal: font_path })
  end

  def save!
    self.render_pdf
    @pdf.render_file(file_name)
  end
end