class ChangeVisitToHpiAuto < ActiveRecord::Migration
  def self.up
    change_table :visits do |t|
      t.change_default :version, "hpi_auto"
      
      t.text :hpi
      
      t.text :ros_general_constitutional
      t.text :ros_HEENT_and_mouth
      t.text :ros_cardiovascular
      t.text :ros_respiratory
      t.text :ros_GI
      t.text :ros_GU
      t.text :ros_musculoskeletal
      t.text :ros_intergumentary
      t.text :ros_endocrine
      t.text :ros_allergy_and_immunologic
      t.text :ros_hematologic_and_lymphatic
      t.text :ros_neurological
      t.text :ros_psychiatric
      
      t.text :pe_genral_appearance
      t.text :pe_head_and_face
      t.text :pe_eyes
      t.text :pe_ENT_and_mouth
      t.text :pe_neck
      t.text :pe_respiratory
      t.text :pe_breast
      t.text :pe_cardiovascular
      t.text :pe_abdomen
      t.text :pe_genitalia_and_rectum
      t.text :pe_extremities
      t.text :pe_back_and_spine
      t.text :pe_psychiatric
      t.text :pe_neurological
      
      t.integer :marital_status_id
      t.integer :living_arrangement_id
      t.integer :education_level_id
      t.integer :pharmacy_id
      
      t.text :disability
      
      t.text :assessment_and_plan
    end
  end

  def self.down
    change_table :visits do |t|
      t.change_default :version, "soap"
      
      t.remove :hpi
      
      t.remove :ros_general_constitutional
      t.remove :ros_HEENT_and_mouth
      t.remove :ros_cardiovascular
      t.remove :ros_respiratory
      t.remove :ros_GI
      t.remove :ros_GU
      t.remove :ros_musculoskeletal
      t.remove :ros_intergumentary
      t.remove :ros_endocrine
      t.remove :ros_allergy_and_immunologic
      t.remove :ros_hematologic_and_lymphatic
      t.remove :ros_neurological
      t.remove :ros_psychiatric
      
      t.remove :pe_genral_appearance
      t.remove :pe_head_and_face
      t.remove :pe_eyes
      t.remove :pe_ENT_and_mouth
      t.remove :pe_neck
      t.remove :pe_respiratory
      t.remove :pe_breast
      t.remove :pe_cardiovascular
      t.remove :pe_abdomen
      t.remove :pe_genitalia_and_rectum
      t.remove :pe_extremities
      t.remove :pe_back_and_spine
      t.remove :pe_psychiatric
      t.remove :pe_neurological
      
      t.remove :marital_status_id
      t.remove :living_arrangement_id
      t.remove :education_level_id
      t.remove :pharmacy_id
      
      t.text :disability
      
      t.remove :assessment_and_plan
    end
  end
end
