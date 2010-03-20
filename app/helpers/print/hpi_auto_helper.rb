require "prawn"
require "prawn/measurement_extensions"

module Print::HpiAutoHelper
def print_hpi_auto(pdf, visit)
  top_box_stamp(pdf, :visit => visit)
  footer_stamp(pdf, 3)
  
  y = page_width_box_text pdf, "Chief Complaint", 8.8.in, 0.5.in, visit.chief_complaint
  
  pdf.bounding_box [0.in, y-0.15.in], :width => 7.5.in, :height => 0.3.in do
    data_box pdf, "BP:", (visit.blood_press_sys&&visit.blood_press_dias ? '%d/%d' % [visit.blood_press_sys, visit.blood_press_dias] : ""), 0.in, 1.875.in
    data_box pdf, "HR:", visit.pulse ? '%d' % visit.pulse : "", 1.875.in, 1.875.in
    data_box pdf, "Temp:", visit.temperature ? '%.1f' % visit.temperature : "", 1.875.in*2, 1.875.in
    data_box pdf, "Weight:", visit.weight ? '%.1f' % visit.weight : "", 1.875.in*3, 1.875.in
  end
  
  y = y - 0.45.in
  
  y = page_width_box_text pdf, "HPI", y-0.15.in, 2.5.in, visit.hpi
  
  page_width_box pdf, "Social History", y-0.15.in, y-0.55.in do
    patient = visit.patient
    pdf.bounding_box [0.in, y-0.65.in], :width => 3.5.in, :height => y-0.75.in do
      #pdf.stroke_bounds
      pdf.text "Living Arrangement: #{visit.living_arrangement.name}", :leading => 3
      pdf.text "Marital Status: #{visit.marital_status.name}", :leading => 3
      space pdf
      pdf.text "Adult Illnesses: #{patient.adult_illness ? (patient.adult_illness.length > 0 ? patient.adult_illness : 'None') : 'None'}", :leading => 3
      space pdf
      pdf.text "Surgeries: #{patient.surgeries ? (patient.surgeries.length > 0 ? patient.surgeries : 'None') : 'None'}", :leading => 3
      space pdf
      pdf.text "Allergies: #{patient.allergies ? (patient.allergies.length > 0 ? patient.allergies : 'None') : 'None'}", :leading => 3
      space pdf
      pdf.text "Childhood Diseases: #{patient.childhood_diseases && patient.childhood_diseases.length>0 ? patient.childhood_diseases.collect{|a| a.to_s}.join(", ") : 'None'}", :leading =>3
      space pdf
      pdf.text "Immunizations: #{(patient.immunization_histories && patient.immunization_histories.length>0) ? patient.immunization_histories.collect{|a| "#{a.to_s}"}.join(", ") : "None"}", :leading => 3
      space pdf
      pdf.text "Family History: #{(patient.family_histories && patient.family_histories.length>0) ? patient.family_histories.collect{|a| "#{a.to_s}"}.join(", ") : "None"}", :leading => 3
    end
    
    pdf.bounding_box [3.85.in, y-0.65.in], :width => 3.5.in, :height => y-0.75.in do
      #pdf.stroke_bounds
      pdf.text "Highest Education: #{visit.education_level.name}", :leading => 3
      pdf.text "Disability: #{visit.disability}", :leading => 3
      space pdf
      pdf.text "Pharmacy: #{visit.pharmacy.name}", :leading => 3
      space pdf
      pdf.text "#{patient.curr_smoking ? 'Current' : (patient.prev_smoking ? 'Previous' : 'No')} Smoking#{(patient.prev_smoking||patient.curr_smoking) ? " - #{patient.smoking_py} py" : ''}", :leading => 3
      pdf.text "#{patient.curr_etoh_use ? 'Current Alcohol Use' : (patient.prev_etoh_use ? 'Previous Alcohol Use' : 'No Alcohol Use')}#{patient.etoh_notes ? (': '+patient.etoh_notes) : ''}", :leading => 3
      pdf.text "#{patient.curr_drug_use ? 'Current Drug Use' : (patient.prev_drug_use ? 'Previous Drug Use' : 'No Drug Use')}#{patient.drug_notes ? (': '+patient.drug_notes) : ''}", :leading => 3

    end
  end
  
  pdf.start_new_page
  
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
    table pdf, data, 'wnl'
  end
  
  pdf.start_new_page
  
  y = page_width_box_text pdf, "Assessment/Plan", 8.8.in, 4.in, visit.assessment_and_plan
  
  y = page_width_box_text pdf, "Referrals", y-0.15.in, 1.5.in, visit.referrals
  
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