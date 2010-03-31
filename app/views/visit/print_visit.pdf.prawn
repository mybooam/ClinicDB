require "prawn"

case @visit.version
when "hpi_auto"
  print_hpi_auto(pdf, @visit)
when "bp_check"
  print_bp_check(pdf, @visit)
when "procedure"
  print_procedure(pdf, @visit)
when "quick_note"
  print_quick_note(pdf, @visit)
end