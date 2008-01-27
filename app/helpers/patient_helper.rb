module PatientHelper
def bod_form_column(record, input_name)
    # with date_select we can use :name
    #date_select :record, :date_received, :name => input_name
    # but if we used select_date we would have to use :prefix
    select_date record[:date_received], :prefix => input_name
  end
end
