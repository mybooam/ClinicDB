require "prawn"
require "prawn/measurement_extensions"

module Print::PrintHelper
  def data_font
    Rails.root.join('public', 'fonts', 'Courier_New.ttf')
  end
  
  def heading_bold_font
    Rails.root.join('public', 'fonts', 'Arial_Bold.ttf')
  end
  
  def heading_font
    Rails.root.join('public', 'fonts', 'Arial.ttf')
  end
  
  def top_gray_level
    "aaaaaa"
  end
  
  def table_gray_level
    "cccccc"
  end
  
  def line_gray_level
    "aaaaaa"
  end
  
  def space(pdf, size = 6)
    pdf.font data_font
    s = pdf.font_size
    pdf.font_size = size
    pdf.text " ", :leading => 0
    pdf.font_size = s
  end
  
  def patient_top_box(pdf, visit)
    pdf.font heading_font
    pdf.font_size = 14
    pdf.bounding_box [0.in, 10.in], :width => 7.5.in, :height => 0.2.in do
      pdf.text "#{Setting.get('visit_form_title', 'Clinic Visit').upcase}", :align => :center
    end
    
    pdf.font_size = 12
    pdf.bounding_box [0.in, 9.75.in], :width => 7.5.in, :height => 0.8.in do
      pdf.fill_color top_gray_level
      pdf.fill_and_stroke do
        pdf.rectangle pdf.bounds.top_left, pdf.bounds.width, pdf.bounds.height
        #pdf.stroke_bounds
      end
      pdf.fill_color "000000"
      
      pdf.bounding_box [0.1.in, 0.7.in], :width => 3.5.in, :height => 0.6.in do
        pdf.text "#{visit.patient.last_name}, #{visit.patient.first_name} - ##{visit.patient.patient_number}", :leading => 2
        pdf.text "DOB: #{visit.patient.dob_str}  (#{visit.patient.age})", :leading => 2
        pdf.text "Race: #{visit.patient.ethnicity}    Sex: #{visit.patient.isMale? ? 'Male' : 'Female'}", :leading => 2
      end
      
      pdf.bounding_box [3.in, 0.7.in], :width => 4.4.in, :height => 0.6.in do
        pdf.text "#{visit.visit_date.strftime('%b %e, %G')} - Visit ##{visit.visit_number}", :align => :right, :leading => 2
        sess = Session.forDate(visit.visit_date)
        pdf.text "Attending: #{sess.attending.to_dr_label}", :align => :right, :leading => 2 if sess
        pdf.text "Seen by: #{visit.users.collect{|u| u.first_initial_last_name}.join(", ")}", :align => :right, :leading => 2
      end
    end
  end
  
  def page_number(pdf)
    pdf.font heading_font
    pdf.font_size=8
    pdf.bounding_box [0, 0.1.in], :width => 7.5.in, :height=>0.2.in do
      pdf.text "Printed #{Time.now.strftime('%m/%d/%Y %H:%M')} by #{session[:user].first_initial_last_name}", :align => :left
    end
    
    pdf.bounding_box [0, 0.1.in], :width => 7.5.in, :height=>0.2.in do
      pdf.text "Page #{pdf.page_number} of 3", :align => :right
    end
  end
  
  def data_box(pdf, label, value, x_pos, width, y_pos=nil, height=nil, options ={})
    pdf.bounding_box [x_pos, y_pos || 0.3.in], :width => width, :height => height || pdf.bounds.height do
      pdf.stroke_bounds
      
      pdf.font heading_font
      pdf.font_size options[:label_size] || options[:size] || 11
      h =  pdf.height_of label
      b = (pdf.bounds.height - h)/2
      pdf.draw_text label, :at => [0.1.in, b+h/6]
      
      pdf.font data_font
      pdf.font_size options[:value_size] || options[:size] || 11
      h =  pdf.height_of value
      b = (pdf.bounds.height - h)/2
      pdf.draw_text value, :at => [0.75.in, b+h/6]
    end
  end
  
  def table(pdf, data, norm_label = 'neg')
    pdf.table data, 
        :headers => ["","n/a",norm_label,""],
        :row_colors => ["ffffff", table_gray_level],
        :vertical_padding => 0.02.in,
        :horizontal_padding => 0.05.in,
        :font_size => 11,
        :align => {0 => :right, 1 => :center, 2 => :center},
        :column_widths => {0 => 1.9.in, 1 => 0.4.in, 2 => 0.4.in, 3 => pdf.bounds.width-2.7.in},
        :border_style => :underline_header
  end
  
  def page_width_box_text(pdf, label, y_pos, height, text, options = {})
    options[:pad] = options[:pad] || 0.1.in
    left_over = ""
    page_width_box pdf, label, y_pos, height, options do
      pdf.text_box "#{text}", :at => pdf.bounds.top_left, :width => pdf.bounds.width, :height => pdf.bounds.height, :leading => 3
    end
  end
  
  def page_width_box(pdf, label, y_pos, height, options = {})
    hpad = options[:hpad] || options[:pad] || 0.1.in
    vpad = options[:vpad] || options[:pad] || 0
    
    if label
      pdf.bounding_box [0, y_pos], :width => 7.5.in, :height => 0.3.in do
        pdf.font heading_font
        pdf.text "#{label}:", :size => 14
      end
      y_pos = y_pos-0.25.in
    end
    
    if(height > 0)
      pdf.bounding_box [0, y_pos], :width => 7.5.in, :height => height do
        if options[:rounded]
          pdf.rounded_rectangle pdf.bounds.top_left, pdf.bounds.width, pdf.bounds.height, 0.05.in
        else
          pdf.stroke_bounds
        end
        
        pdf.bounding_box [hpad, pdf.bounds.height-vpad], :width => pdf.bounds.width-hpad*2, :height => pdf.bounds.height-vpad*2 do
          pdf.font options[:font] || data_font
          pdf.font_size options[:font_size] || 11
          yield
        end
      end
      y_pos-height
    else
      pdf.bounding_box [0, y_pos], :width => 7.5.in do
        if options[:rounded]
          pdf.rounded_rectangle pdf.bounds.top_left, pdf.bounds.width, pdf.bounds.height, 0.05.in
        else
          pdf.stroke_bounds
        end
        pdf.pad 0.1.in do
          pdf.indent 0.1.in do
            pdf.font options[:font] || data_font
            pdf.font_size options[:font_size] || 11
            yield
          end
        end
      end
      pdf.y
    end
  end
end
