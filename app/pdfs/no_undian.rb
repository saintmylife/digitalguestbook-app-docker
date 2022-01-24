class NoUndianPdf < Prawn::Document
  def initialize
    super
    text 'No Undian goes here'
  end
end
