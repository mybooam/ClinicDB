require "date"
require "prawn"
require "prawn/measurement_extensions"

module Print::TbTestHistoryPrintHelper
  def print_tb_test_history(pdf, patient)
    top_box_stamp(pdf, :patient => patient, :title => Setting.get("tb_test_history_header", "Tuberculin Skin Test History"))
    footer_stamp(pdf, 1)
    
    page_width_box pdf, "TB Tests", 8.7.in, 0 do
      data = []
      pdf.font data_font
      for tb_test in patient.tb_tests.sort{|a,b| b.given_date <=> a.given_date}
        row = ["#{tb_test.given_date.strftime('%b %e, %G')}"]
        if tb_test.read?
          if tb_test.positive?
            row << "POSITIVE"
          elsif tb_test.negative?
            row << "Negative"
          elsif tb_test.unknown?
            row << "Unknown"
          end
        elsif tb_test.open? && !tb_test.overdue?
          row << "Due #{tb_test.due_date_min.strftime('%m/%e')}-#{tb_test.due_date_max.strftime('%m/%e')}"
        else
          row << "NOT READ"
        end
        row << "#{tb_test.notes}"
        data << row
      end
      
      unless data.empty? 
        pdf.table data, 
          :headers => ["Date","Result","Notes"],
          :row_colors => ["ffffff", table_gray_level],
          :vertical_padding => 0.05.in,
          :horizontal_padding => 0.05.in,
          :font_size => 11,
          :align => {0 => :left, 1 => :left, 2 => :left},
          :column_widths => {0 => 1.5.in, 1 => 1.5.in, 2 => pdf.bounds.width - 3.in},
          :border_style => :underline_header
      else
        pdf.text " "
        pdf.text "- No TB Tests in Records- ", :align => :center
      end
    end
    
    pdf.horizontal_line 0, pdf.bounds.width #, :at => 0.1.in
  end
end