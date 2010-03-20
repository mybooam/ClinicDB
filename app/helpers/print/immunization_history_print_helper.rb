require "date"
require "prawn"
require "prawn/measurement_extensions"

module Print::ImmunizationHistoryPrintHelper
  def print_immunization_history(pdf, patient)
    top_box_stamp(pdf, :patient => patient, :title => Setting.get("immunization_history_header", "Immunization History"))
    footer_stamp(pdf, 1)
    
    page_width_box pdf, "Immunizations", 8.7.in, 0 do
      data = []
      pdf.font data_font
      for imm in patient.immunizations.sort{|a,b| b.given_date <=> a.given_date}
        row = [imm.name]
        row << "#{imm.given_date.strftime('%b%e, %G')}"
        row << "#{imm.lot_number}"
        data << row
      end
      
      unless data.empty? 
        pdf.table data, 
          :headers => ["","Date","Lot #"],
          :row_colors => ["ffffff", table_gray_level],
          :vertical_padding => 0.05.in,
          :horizontal_padding => 0.05.in,
          :font_size => 11,
          :align => {0 => :left, 1 => :left, 2 => :left},
          :column_widths => {0 => 3.in, 1 => 1.5.in, 2 => pdf.bounds.width - 4.5.in},
          :border_style => :underline_header
      else
        pdf.text " "
        pdf.text "- No Immunizations in Records- ", :align => :center
      end
    end
    
    pdf.horizontal_line 0, pdf.bounds.width #, :at => 0.1.in
  end
end