require "prawn"
require "prawn/measurement_extensions"

module Print::BpCheckHelper
  def print_bp_check(pdf, visit)
    top_box_stamp(pdf, :visit => visit, :title => Setting.get("bp_check_visit_header", "BP Check Note"))
    footer_stamp(pdf, 1)
    
    y = 8.8.in
    
    pdf.bounding_box [0.in, y-0.15.in], :width => 7.5.in, :height => 0.3.in do
      data_box pdf, "BP:", (visit.blood_press_sys&&visit.blood_press_dias ? '%d/%d' % [visit.blood_press_sys, visit.blood_press_dias] : ""), 0.in, 1.875.in
      data_box pdf, "HR:", visit.pulse ? '%d' % visit.pulse : "", 1.875.in, 1.875.in
      data_box pdf, "Temp:", visit.temperature ? '%.1f' % visit.temperature : "", 1.875.in*2, 1.875.in
      data_box pdf, "Weight:", visit.weight ? '%.1f' % visit.weight : "", 1.875.in*3, 1.875.in
    end
    
    y = y - 0.45.in
    
    y = page_width_box_text pdf, "Notes", y-0.15.in, 1.5.in, visit.hpi
    
    y = page_width_box_text pdf, "Assessment/Plan", y-0.15.in, 2.in, visit.assessment_and_plan
    
    y = page_width_box_text pdf, "Referrals", y-0.15.in, 1.in, visit.referrals
    
    y = page_width_box pdf, "Attending Note", y-0.15.in, y-0.55.in do
      pdf.stroke do
        pdf.line [3.in, 0.5.in], [7.4.in, 0.5.in]
        pdf.line [3.in, 0.5.in], [3.in, 0.in]
      end
      
      pdf.font heading_font
      pdf.draw_text "Attending Signature", :size => 7, :at => [3.1.in, 0.05.in]
      pdf.draw_text "Date", :size => 7, :at => [6.1.in, 0.05.in]
      
      l = pdf.line_width
      pdf.line_width = 0.5
      pdf.stroke_color line_gray_level
      pdf.stroke do
        a = pdf.bounds.height - 0.25.in
        while(a>0.5.in)
          pdf.horizontal_line 0.05.in, 7.25.in, :at => a
          a -= 0.25.in
        end
        pdf.horizontal_line 0.05.in, 2.9.in, :at => a
      end
      pdf.line_width = l
      pdf.stroke_color "000000"
    end
  end
end