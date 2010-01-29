class CreateEducationLevels < ActiveRecord::Migration
  def self.up
    create_table :education_levels do |t|
      t.string :name

      t.timestamps
    end
    
    EducationLevel.create(:name => "None")
    EducationLevel.create(:name => "Elementary School")
    EducationLevel.create(:name => "Junior High School")
    EducationLevel.create(:name => "High School")
    EducationLevel.create(:name => "College")
  end

  def self.down
    drop_table :education_levels
  end
end
