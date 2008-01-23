class PopulateChoices < ActiveRecord::Migration
  def self.up
    Ethnicity.create :name => "White"
    Ethnicity.create :name => "African American"
    Ethnicity.create :name => "Hispanic"
    Ethnicity.create :name => "Asian/Pacific Islander"
    Ethnicity.create :name => "Other"
    
    FamilyHistoryChoice.create :name => "Diabetes"
    FamilyHistoryChoice.create :name => "Hypertension"
    FamilyHistoryChoice.create :name => "Ischemic Heart Disease"
    FamilyHistoryChoice.create :name => "Mental Illness"
    FamilyHistoryChoice.create :name => "Stroke"
    FamilyHistoryChoice.create :name => "Kidney Disease"
    FamilyHistoryChoice.create :name => "Cancer"
    FamilyHistoryChoice.create :name => "Tuberculosis"
    FamilyHistoryChoice.create :name => "Arthritis"
    FamilyHistoryChoice.create :name => "Hematological Disease"
    
    ChildhoodDiseaseChoice.create :name => "Measles"
    ChildhoodDiseaseChoice.create :name => "Mumps"
    ChildhoodDiseaseChoice.create :name => "Rubella"
    ChildhoodDiseaseChoice.create :name => "Chicken Pox"
    ChildhoodDiseaseChoice.create :name => "Scarlet Fever"
    ChildhoodDiseaseChoice.create :name => "Polio"
    ChildhoodDiseaseChoice.create :name => "Rheumatic Fever"
    ChildhoodDiseaseChoice.create :name => "Whooping Cough"
    
    ImmunizationChoice.create :name => "Measles"
    ImmunizationChoice.create :name => "Mumps"
    ImmunizationChoice.create :name => "Rubella"
    ImmunizationChoice.create :name => "Polio"
    ImmunizationChoice.create :name => "Pnemococcal"
    ImmunizationChoice.create :name => "Hepatitis B"
  end

  def self.down
  end
end
