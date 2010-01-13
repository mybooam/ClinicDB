class TransactionController < ApplicationController
  def list_for_user
    @transactions = Transaction.for_user(params[:user_id])
  end
end