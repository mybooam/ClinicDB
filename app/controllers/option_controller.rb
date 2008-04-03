class OptionController < ApplicationController
  def index
    @options = get_options
  end
  
  def add
    name = params[:item][:name]
    key = params[:item][:key]
    option = get_options[key]
    
    case key
    when "childhood_disease" then
      item = ChildhoodDisease.new(:name => name)
    when "ethnicities" then
      item = Ethnicity.new(:name => name)
    when "family_histories" then
      item = FamilyHistory.new(:name => name)
    when "immunization_histories" then
      item = ImmunizationHistory.new(:name => name)
    when "immunization_drugs" then
      item = ImmunizationDrug.new(:name => name)
    else
      flash[:error] = "Could not add new option"
      redirect_to :back
      return
    end
    
    if item.save
      flash[:notice] = "New #{option[:label]} added: #{item.name}"
      redirect_to :action => "index"
    else
      flash[:error] = "Could not add new option"
      redirect_to :back
    end
  end
  
  def edit
    @name = params[:name]
    @item_id = params[:item_id]
    @key = params[:key]
    @label = get_options[@key][:label]
  end
  
  def update
    item_id = params[:item][:item_id]
    key = params[:item][:key]
    option = get_options[key]
    name = params[:item][:name]
    
    if name.size == 0
      flash[:error] = "Cannot have blank name."
      redirect_to :back
      return
    end
    
    case key
    when "childhood_disease" then
      result = ChildhoodDisease.update(item_id, :name => name)
    when "ethnicities" then
      result = Ethnicity.update(item_id, :name => name)
    when "family_histories" then
      result = FamilyHistory.update(item_id, :name => name)
    when "immunization_histories" then
      result = ImmunizationHistory.update(item_id, :name => name)
    when "immunization_drugs" then
      result = ImmunizationDrug.update(item_id, :name => name)
    else
      flash[:error] = "Could not update option"
      redirect_to :back
      return
    end
    
    if result
      flash[:notice] = "#{option[:label]} updated: #{name}"
      redirect_to :action => "index"
    else
      flash[:error] = "Could not update option"
      redirect_to :back
    end
  end
  
  def delete
    item_id = params[:item_id]
    key = params[:key]
    option = get_options[key]
    
    case key
    when "childhood_disease" then
      name = ChildhoodDisease.find(item_id).name
      result = ChildhoodDisease.delete(item_id)
    when "ethnicities" then
      name = Ethnicity.find(item_id).name
      result = Ethnicity.delete(item_id)
    when "family_histories" then
      name = FamilyHistory.find(item_id).name
      result = FamilyHistory.delete(item_id)
    when "immunization_histories" then
      name = ImmunizationHistory.find(item_id).name
      result = ImmunizationHistory.delete(item_id)
    when "immunization_drugs" then
      name = ImmunizationDrug.find(item_id).name
      result = ImmunizationDrug.delete(item_id)
    else
      flash[:error] = "Could not delete option"
      redirect_to :back
      return
    end
    
    if result
      flash[:notice] = "#{option[:label]} deleted: #{name}"
      redirect_to :action => "index"
    else
      flash[:error] = "Could not delete option"
      redirect_to :back
    end
  end
  
  def get_options
    options = {}
    options["childhood_diseases"] = { :label => "Childhood Disease", :linked_to => "patients", :items => ChildhoodDisease.find(:all) }
    options["ethnicities"] = { :label => "Ethnicity", :linked_to => "patients", :items => Ethnicity.find(:all) }
    options["family_histories"] = { :label => "Family History Item", :linked_to => "patients", :items => FamilyHistory.find(:all) }
    options["immunization_histories"] = { :label => "Previous Immunization", :linked_to => "patients", :items => ImmunizationHistory.find(:all) }
    options["immunization_drugs"] = { :label => "Avaliable Immunization", :linked_to => "immunizations", :items => ImmunizationDrug.find(:all) }
    options
  end
end