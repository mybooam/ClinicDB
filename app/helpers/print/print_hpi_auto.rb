require "prawn"
require "prawn/measurement_extensions"

def data_font
  Rails.root.join('public', 'fonts', 'Courier_New.ttf')
end

def heading_bold_font
  Rails.root.join('public', 'fonts', 'Arial_Bold.ttf')
end

def heading_font
  Rails.root.join('public', 'fonts', 'Arial.ttf')
end

def patient_top_box(pdf, visit)
  pdf.font heading_font
  pdf.font_size = 14
  pdf.bounding_box [0.in, 10.in], :width => 7.5.in, :height => 0.2.in do
    pdf.text "#{Setting.get('visit_form_title', 'Clinic Visit').upcase}", :align => :center
  end
  
  pdf.font_size = 12
  pdf.bounding_box [0.in, 9.8.in], :width => 7.5.in, :height => 0.8.in do
    pdf.stroke_bounds
    
    pdf.bounding_box [0.1.in, 0.7.in], :width => 3.5.in, :height => 0.6.in do
      pdf.text "#{visit.patient.last_name}, #{visit.patient.last_name}", :leading => 2
      pdf.text "DOB: #{visit.patient.dob_str}", :leading => 2
      pdf.text "Age: #{visit.patient.age}    Race: #{visit.patient.ethnicity}", :leading => 2
    end
    
    pdf.bounding_box [3.in, 0.7.in], :width => 4.4.in, :height => 0.6.in do
      pdf.text "#{visit.visit_date.strftime('%b %e, %G')}", :align => :right, :leading => 2
      sess = Session.forDate(visit.visit_date)
      pdf.text "Attending: #{sess.attending.to_label}", :align => :right, :leading => 2 if sess
      pdf.text "Seen by: #{visit.users.collect{|u| u.to_label}.join(", ")}", :align => :right, :leading => 2
    end
  end
end

def page_number(pdf)
  pdf.font heading_font
  pdf.font_size=8
  pdf.bounding_box [0, -0.1.in], :width => 7.5.in, :height=>0.2.in do
    pdf.text "Page #{pdf.page_number} of 3", :align => :right
  end
end

def data_box(pdf, label, value, x_pos, width)
  pdf.bounding_box [x_pos, 0.3.in], :width => width, :height => pdf.bounds.height do
    pdf.stroke_bounds
    
    pdf.font heading_font
    pdf.font_size 11
    h =  pdf.font.height
    b = (pdf.bounds.height - h)/2
    w = 0.75.in
    pdf.bounding_box [0.1.in, (pdf.bounds.height-b)], :width => w, :height => h do
      pdf.text label
    end
    
    pdf.font data_font
    pdf.font_size 11
    h =  pdf.font.height+0.05.in
    b = (pdf.bounds.height - h)/2
    pdf.bounding_box [w, (pdf.bounds.height-b)], :width => (pdf.bounds.width-w-0.1.in), :height => h do
      pdf.text value, :valign => :center
    end
  end
end

def table(pdf, data)
  pdf.table data, 
      :headers => ["","n/a","wnl",""],
      :row_colors => ["ffffff","f0f0f0"],
      :vertical_padding => 0.02.in,
      :horizontal_padding => 0.05.in,
      :font_size => 11,
      :align => {0 => :right, 1 => :center, 2 => :center},
      :column_widths => {0 => 1.9.in, 1 => 0.4.in, 2 => 0.4.in, 3 => pdf.bounds.width-2.7.in},
      :border_style => :underline_header
end

def page_width_box_text(pdf, label, y_pos, height, text)
  page_width_box pdf, label, y_pos, height do
    pdf.text "#{text}", :leading => 3
  end
end

def page_width_box(pdf, label, y_pos, height)
  pdf.bounding_box [0, y_pos], :width => 7.5.in, :height => 0.3.in do
    pdf.font heading_font
    pdf.text "#{label}:", :size => 14
  end
  
  if(height > 0)
    pdf.bounding_box [0, y_pos-0.25.in], :width => 7.5.in, :height => height do
      pdf.stroke_bounds
      pdf.bounding_box [0.1.in, height-0.1.in], :width => 7.3.in, :height => (height-0.2.in) do
        pdf.font data_font
        pdf.font_size 11
        yield
      end
    end
    y_pos-0.25.in-height
  else
    pdf.bounding_box [0, y_pos-0.25.in], :width => 7.5.in do
      pdf.stroke_bounds
      pdf.bounding_box [0.1.in, height-0.1.in], :width => 7.3.in do
        pdf.font data_font
        pdf.font_size 11
        yield
      end
    end
    pdf.y
  end
end


def print(pdf, visit)
  patient_top_box(pdf, visit)
  page_number(pdf)
  
  pdf.bounding_box [0.in, 8.8.in], :width => 7.5.in, :height => 0.3.in do
    data_box pdf, "BP:", (visit.blood_press_sys&&visit.blood_press_dias ? '%d/%d' % [visit.blood_press_sys, visit.blood_press_dias] : ""), 0.in, 1.875.in
    data_box pdf, "HR:", visit.pulse ? '%d' % visit.pulse : "", 1.875.in, 1.875.in
    data_box pdf, "Temp:", visit.temperature ? '%.1f' % visit.temperature : "", 1.875.in*2, 1.875.in
    data_box pdf, "Weight:", visit.weight ? '%.1f' % visit.weight : "", 1.875.in*3, 1.875.in
  end
  
  y = page_width_box_text pdf, "Chief Complaint", 8.3.in, 0.5.in, visit.chief_complaint
  
  y = page_width_box_text pdf, "HPI", y-0.15.in, 2.5.in, visit.hpi
  
  page_width_box pdf, "Social History", y-0.15.in, 0.8.in do
    pdf.bounding_box [0.in, 0.6.in], :width => 3.5.in, :height => 0.6.in do
      pdf.text "Living Arrangement: #{visit.living_arrangement.name}"
      pdf.text "Marital Status: #{visit.marital_status.name}"
    end
    
    pdf.bounding_box [3.85.in, 0.6.in], :width => 3.5.in, :height => 0.6.in do
      pdf.text "Highest Education: #{visit.education_level.name}"
      pdf.text "Disability: #{visit.disability}"
      pdf.text "Pharmacy: #{visit.pharmacy.name}"
    end
  end
  
  pdf.start_new_page
  
  patient_top_box(pdf, visit)
  page_number(pdf)
  
  y = page_width_box pdf, "Review of Systems", 8.7.in, 0 do
  #pdf.bounding_box [0, 8.7.in], :width => 7.5.in do
    data = []
    pdf.font data_font
    for label in Visit.column_names.select{|k| k.starts_with?("ros_") }
      t = visit[label]
      row = [hp_label(label)]
      row << (t=='n/a' ? "X" : "")
      row << (t=='neg'||t=='wnl' ? "X" : "")
      row << (t!='n/a'&&t!='neg'&&t!='wnl' ? t : "")
      data << row
    end
    table pdf, data
  end
  
  y = page_width_box pdf, "Physical Exam", y-0.75.in, 0 do
  #pdf.bounding_box [0, y], :width => 7.5.in do
    data = []
    pdf.font data_font
    for label in Visit.column_names.select{|k| k.starts_with?("pe_") }
      t = visit[label]
      row = [hp_label(label)]
      row << (t=='n/a' ? "X" : "")
      row << (t=='neg'||t=='wnl' ? "X" : "")
      row << (t!='n/a'&&t!='neg'&&t!='wnl' ? t : "")
      data << row
    end
    table pdf, data
  end
  
  pdf.start_new_page
  
  patient_top_box(pdf, visit)
  page_number(pdf)
  
  y = page_width_box_text pdf, "Assessment/Plan", 8.8.in, 4.in, visit.assessment_and_plan
  
  y = page_width_box_text pdf, "Referrals", y-0.15.in, 1.5.in, visit.referrals
  
  y = page_width_box pdf, "Attending Note", y-0.15.in, 2.in do
    pdf.line [0.in, 1.in], [7.2.in, 1.in]
      #(0..5).each do |a|
      # puts (a*0.2+0.3)
      # pdf.horizontal_line 0.1.in, 7.2.in, :at => pdf.bounds.height-(a*0.2+0.3).in
      #end
  end
end