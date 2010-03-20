require "prawn"
require "prawn/measurement_extensions"

module Print::ImmunizationHistoryPrintHelper
  def print_immunization_history(pdf, patient)
    patient_top_box(pdf, :patient => patient, :title => "Immunization History")
    page_number(pdf)
    
    page_width_box pdf, "Immunizations", 8.7.in, 0 do
      data = []
      pdf.font data_font
      for imm in patient.immunizations.sort{|a,b| b.given_date <=> a.given_date}
        row = [imm.immunization_drug]
        row << "#{imm.given_date.strftime('%b %e, %G')}"
        row << "#{imm.lot_number}"
        data << row
      end
      
      
      pdf.table data, 
        :headers => ["","Date","Lot #"],
        :row_colors => ["ffffff", table_gray_level],
        :vertical_padding => 0.05.in,
        :horizontal_padding => 0.05.in,
        :font_size => 11,
        :align => {0 => :left, 1 => :left, 2 => :left},
        :column_widths => {0 => 3.in, 1 => 1.5.in, 2 => pdf.bounds.width - 4.5.in},
        :border_style => :underline_header
    end
  end
end