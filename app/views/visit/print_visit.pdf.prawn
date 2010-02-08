require "prawn"
require "app/views/visit/#{@visit.version}/print_hpi_auto"

print(pdf, @visit)