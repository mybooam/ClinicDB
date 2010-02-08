require "prawn"
require "prawn/measurement_extensions"

@arial_bold_font = Rails.root.join('public', 'fonts', 'Arial_Bold.ttf')
@arial_font = Rails.root.join('public', 'fonts', 'Arial.ttf').to_s
@courier_new_font = Rails.root.join('public', 'fonts', 'Courier_New.ttf')

#puts @arial_bold_font.to_s
#puts @arial_font.to_s
#puts @courier_new_font.to_s

def patient_top_box(pdf, visit)
  pdf.font_size = 14
  pdf.bounding_box [0.in, 10.in], :width => 7.5.in, :height => 0.2.in do
    pdf.text "#{Setting.get('visit_form_title', 'LSUHSC Homeless Clinic - Ozanam Inn').upcase}", :align => :center
  end
  
  pdf.font_size = 12
  pdf.bounding_box [0.in, 9.8.in], :width => 7.5.in, :height => 0.8.in do
    pdf.stroke_bounds
    
    pdf.bounding_box [0.1.in, 0.7.in], :width => 3.5.in, :height => 0.6.in do
      pdf.text "#{visit.patient.last_name}, #{visit.patient.last_name}"
      pdf.text "DOB: #{visit.patient.dob_str}"
      pdf.text "Age: #{visit.patient.age}    Race: #{visit.patient.ethnicity}"
    end
    
    pdf.bounding_box [3.in, 0.7.in], :width => 4.4.in, :height => 0.6.in do
      pdf.text "Date: #{visit.visit_date.strftime('%A, %B %e, %Y')}", :align => :right
      sess = Session.forDate(visit.visit_date)
      pdf.text "Attending: #{sess.attending.to_label}", :align => :right if sess
      pdf.text "Seen by: #{visit.users.collect{|u| u.to_label}.join(", ")}", :align => :right
    end
  end
end

def page_number(pdf)
  pdf.font_size=8
  pdf.bounding_box [0, -0.1.in], :width => 7.5.in, :height=>0.2.in do
    pdf.text "Page #{pdf.page_number} of 2", :align => :right
  end
end

def data_box(pdf, label, value, x_pos, width)
  pdf.bounding_box [x_pos, 0.3.in], :width => width, :height => pdf.bounds.height do
    pdf.stroke_bounds
    
    pdf.font @arial_font
    h =  pdf.font.height
    b = (pdf.bounds.height - h)/2
    w = 0.75.in
    pdf.bounding_box [0.1.in, (pdf.bounds.height-b)], :width => w, :height => h do  
      pdf.text label
    end
    
    pdf.font @courier_new_font
    h =  pdf.font.height
    b = (pdf.bounds.height - h)/2
    pdf.bounding_box [w, (pdf.bounds.height-b)], :width => (pdf.bounds.width-w), :height => h do
      pdf.text value
    end
  end
end


def print(pdf, visit)
  patient_top_box(pdf, visit)
  page_number(pdf)
  
  pdf.font_size = 10
  
  pdf.bounding_box [0.in, 8.9.in], :width => 7.5.in, :height => 0.3.in do
    data_box pdf, "BP:", (visit.blood_press_sys&&visit.blood_press_dias ? '%d/%d' % [visit.blood_press_sys, visit.blood_press_dias] : ""), 0.in, 1.875.in
    data_box pdf, "HR:", visit.pulse ? '%d' % visit.pulse : "", 1.875.in, 1.875.in
    data_box pdf, "Temp:", visit.temperature ? '%.1f' % visit.temperature : "", 1.875.in*2, 1.875.in
    data_box pdf, "Weight:", visit.weight ? '%.1f' % visit.weight : "", 1.875.in*3, 1.875.in
  end
  
  pdf.bounding_box [0, 8.5.in], :width => 7.5.in, :height => 0.3.in do
    pdf.stroke_bounds
    pdf.pad 0.07.in do
      pdf.text "Chief Complaint: #{visit.chief_complaint}"
    end
  end
  
  pdf.bounding_box [0, 8.1.in], :width => 7.5.in, :height => 1.5.in do
    pdf.stroke_bounds
    pdf.bounding_box [0.1.in, 1.4.in], :width => 7.3.in, :height => 1.3.in do
      pdf.text "HPI:", :size =>14
      pdf.font @courier_new_font
      pdf.text "#{visit.hpi}"
      pdf.font @arial_font
    end
  end
  
  pdf.bounding_box [0, 6.5.in], :width => 7.5.in, :height => 0.8.in do
    pdf.stroke_bounds
    pdf.bounding_box [0.1.in, 0.7.in], :width => 3.5.in, :height => 0.6.in do
      pdf.text "Social History:", :size => 14
      pdf.text "Living Arrangement: #{visit.living_arrangement.name}"
      pdf.text "Marital Status: #{visit.marital_status.name}"
    end
    
    pdf.bounding_box [3.85.in, 0.7.in], :width => 3.5.in, :height => 0.6.in do
      pdf.text "Highest Education: #{visit.education_level.name}"
      pdf.text "Disability: #{visit.disability}"
      pdf.text "Pharmacy: #{visit.pharmacy.name}"
    end
  end
  
  pdf.bounding_box [0, 5.5.in], :width => 7.5.in do
    data = []
    for label in Visit.column_names.select{|k| k.starts_with?("ros_") }
      t = visit[label]
      row = [hp_label(label)]
      row << (t=='n/a' ? "X" : "")
      row << (t=='neg'||t=='wnl' ? "X" : "")
      row << (t!='n/a'&&t!='neg'&&t!='wnl' ? t : "")
      data << row
    end
    pdf.table data, 
      :headers => ["","n/a","neg",""],
      :row_colors => ["ffffff","f0f0f0"],
      :vertical_padding => 0.02.in,
      :horizontal_padding => 0.0.in,
      :font_size => 10,
      :align => {0 => :right, 1 => :center, 2 => :center},
      :column_widths => {0 => 1.9.in, 1 => 0.31.in, 2 => 0.31.in, 3 => pdf.bounds.width-2.52.in},
      :border_style => :underline_header
  end
  
  pdf.bounding_box [0.1.in, 5.5.in], :width => 1.75.in, :height => 0.2.in do
      pdf.text "Review of Systems:", :size => 14
  end
  
  pdf.start_new_page
  
  patient_top_box(pdf, visit)
  page_number(pdf)
  
  pdf.font_size = 10
  
  pdf.bounding_box [0, 8.8.in], :width => 7.5.in do
    #pdf.stroke_bounds
    data = []
    for label in Visit.column_names.select{|k| k.starts_with?("pe_") }
      t = visit[label]
      row = [hp_label(label)]
      row << (t=='n/a' ? "X" : "")
      row << (t=='neg'||t=='wnl' ? "X" : "")
      row << (t!='n/a'&&t!='neg'&&t!='wnl' ? t : "")
      data << row
    end
    pdf.table data, 
      :headers => ["","n/a","wnl",""],
      :row_colors => ["ffffff","fafafa"],
      :vertical_padding => 0.02.in,
      :horizontal_padding => 0.05.in,
      :font_size => 10,
      :align => {0 => :right, 1 => :center, 2 => :center},
      :column_widths => {0 => 1.9.in, 1 => 0.31.in, 2 => 0.31.in, 3 => pdf.bounds.width-2.52.in},
      :border_style => :underline_header
  end
  
  pdf.bounding_box [0.1.in, 8.8.in], :width => 1.75.in, :height => 0.2.in do
      pdf.text "Physical Exam:", :size => 14
  end
  
  pdf.bounding_box [0, 4.3.in], :width => 7.5.in, :height => 1.5.in do
    pdf.stroke_bounds
    pdf.bounding_box [0.1.in, 1.4.in], :width => 7.3.in, :height => 1.3.in do
      pdf.font @arial_font
      pdf.text "Assessment/Plan:", :size => 14
      pdf.font @courier_new_font
      pdf.text "#{visit.assessment_and_plan}"
    end
  end
  
  pdf.bounding_box [0, 2.7.in], :width => 7.5.in, :height => 1.in do
    pdf.stroke_bounds
    pdf.bounding_box [0.1.in, 0.9.in], :width => 7.3.in, :height => 0.8.in do
      pdf.font @arial_font
      pdf.text "Referrals:", :size => 14
      pdf.font @courier_new_font
      pdf.text "#{visit.referrals}"
    end
  end
  
  pdf.bounding_box [0, 1.6.in], :width => 7.5.in, :height => 1.6.in do
    pdf.stroke_bounds
    pdf.bounding_box [0.1.in, 1.5.in], :width => 7.3.in, :height => 1.4.in do
      pdf.text "Attending Note:", :size => 14
      pdf.line [0.in, 1.in], [7.2.in, 1.in]
      #(0..5).each do |a|
      # puts (a*0.2+0.3)
      # pdf.horizontal_line 0.1.in, 7.2.in, :at => pdf.bounds.height-(a*0.2+0.3).in
      #end
    end
  end
end