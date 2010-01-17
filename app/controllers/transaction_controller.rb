class TransactionController < ApplicationController
  def list_for_user
    @transactions = Transaction.for_user(params[:user_id])
    @user = User.find(params[:user_id])
  end
  
   def list_for_patient
    @transactions = Transaction.for_patient(params[:patient_id])
    @patient = Patient.find(params[:patient_id])
  end
end