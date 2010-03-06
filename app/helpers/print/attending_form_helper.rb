require "prawn"
require "prawn/measurement_extensions"

module Print::AttendingFormHelper
  def print_attending_form(pdf)
  pdf.font heading_font
  pdf.font_size = 14
  pdf.bounding_box [0.in, 10.in], :width => 7.5.in, :height => 0.2.in do
    pdf.text "#{Setting.get('visit_form_title', 'Clinic Visit').upcase} - DOWNTIME FORM", :align => :center
  end
  
  y = page_width_box pdf, nil, 9.75.in, 1.4.in, {:rounded => true} do
    data_box pdf, "Patient #:", "", 0.in, 2.in, pdf.bounds.height-0.1.in, 0.4.in, :label_size => 14
    data_box pdf, "Visit #:", "", 2.125.in, 2.in, pdf.bounds.height-0.1.in, 0.4.in, :label_size => 14
    
    pdf.bounding_box [4.25.in, pdf.bounds.height-0.1.in], :width => 0.75.in, :height => 0.4.in do
      #pdf.stroke_bounds
      pdf.stroke do
        pdf.horizontal_line 0.05.in, 0.7.in, :at => pdf.bounds.height/2
        pdf.line [0.05.in, pdf.bounds.height/2], [0.15.in, pdf.bounds.height/2+0.05.in]
        pdf.line [0.05.in, pdf.bounds.height/2], [0.15.in, pdf.bounds.height/2-0.05.in]
      end
    end
    
    pdf.bounding_box [5.1.in, pdf.bounds.height-0.1.in], :width => 2.25.in, :height => 0.4.in do
      #pdf.stroke_bounds
      pdf.font heading_font
      pdf.text "Find this information on the patient's EMR page", :leading => 3, :valign => :center
    end
    
    pdf.stroke do
      pdf.dash 0.05.in
      pdf.horizontal_line 0.0.in, pdf.bounds.width, :at => 0.75.in
    end
    pdf.undash
    
    pdf.bounding_box [0, 0.6.in], :width => pdf.bounds.width do
      pdf.text "Patient Name: _____________________________    Date of Birth: _______________    Sex: _________", :leading => 10
      pdf.text "Date of Visit: _______________    Seen by: _________________________________________________", :leading => 3
    end
  end

  y = page_width_box pdf, "Attending Note", y-0.2.in, 6.75.in, :rounded => true do
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
  
  page_width_box_text pdf, nil, y-0.2.in, y-0.25.in, 
    ["This form is to be used only when the printing of EMR visit notes is not possible.",
    "Place this form, with the attending's note and signature, in the patient's chart.  Once the EMR becomes",
    "available, print out the visit note and place it in front of this form.",
    ].join(" "),
    :font => heading_font, :rounded => true
end
end