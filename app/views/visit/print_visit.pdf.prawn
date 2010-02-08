require "prawn"
require "app/helpers/print/print_#{@visit.version}"

print(pdf, @visit)