require "prawn"
require "prawn/measurement_extensions"

module Print::QuickNoteHelper
  def print_quick_note(pdf, visit)
    top_box_stamp(pdf, :visit => visit, :title => Setting.get("quick_note_visit_header", "Quick Note"))
    footer_stamp(pdf, 1)
    
    page_width_box_text pdf, nil, 8.8.in, 8.8.in-0.3.in, visit.hpi
  end
end