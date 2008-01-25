class PopulateChoices < ActiveRecord::Migration
  def self.up
	ChildhoodDisease.create :name => "Measles"
	ChildhoodDisease.create :name => "Mumps"
	ChildhoodDisease.create :name => "Rubella"
	ChildhoodDisease.create :name => "Scarlet Fever"
	ChildhoodDisease.create :name => "Rheumatic Fever"
	ChildhoodDisease.create :name => "Whooping Cough"
	ChildhoodDisease.create :name => "Chicken Pox"
	ChildhoodDisease.create :name => "Polio"
	
	ImmunizationHistory.create :name=>"Measles"
	ImmunizationHistory.create :name=>"Mumps"
	ImmunizationHistory.create :name=>"Rubella"
	ImmunizationHistory.create :name=>"Polio"
	ImmunizationHistory.create :name=>"Hepatitis B"
	
	FamilyHistory.create :name => "Hypertension"
	FamilyHistory.create :name => "Diabetes"
	FamilyHistory.create :name => "Cancer"
	FamilyHistory.create :name => "Ischemic Heart Disease"
	FamilyHistory.create :name => "Stroke"
	FamilyHistory.create :name => "Kidney Disease"
	FamilyHistory.create :name => "TB"
	FamilyHistory.create :name => "Arthritis"
	FamilyHistory.create :name => "Mental Illness"
	FamilyHistory.create :name => "Hematological Disease"
	
	Ethnicity.create :name => "White"
	Ethnicity.create :name => "African American"
	Ethnicity.create :name => "Hispanic"
	Ethnicity.create :name => "Asian/Pacific Islander"
	Ethnicity.create :name => "Other"
	
	Drug.create :name => "Tylenol", :units => "mg"
	Drug.create :name => "Asprin", :units => "mg"
	Drug.create :name => "Ibuprofen", :units => "mg"
	
	ImmunizationDrug.create :name => "Fluvax"
	
  end

  def self.down
  end
end
