require "prawn"

case @visit.version
when "hpi_auto"
  print_hpi_auto(pdf, @visit)
end