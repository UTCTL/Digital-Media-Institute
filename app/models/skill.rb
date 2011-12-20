# == Schema Information
#
# Table name: skills
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  description :text
#  icon        :string(255)
#  slug        :string(255)
#  lft         :integer
#  rgt         :integer
#  parent_id   :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Skill < ActiveRecord::Base
  acts_as_nested_set
  
  attr_accessible :title, :description, :icon, :parent_id
  
  validate :only_one_root
  validates :title, :presence => true 
  
  has_many :lessons, :order => "list_scope, position" 
  
  before_save :create_slug
  
  private
    
    def only_one_root

      if self.parent_id.nil? && Skill.root
        errors.add(:base, "There can be only one root Skill object")
      end

    end
    
    def create_slug
      
      if self.root?
        self.slug = ""
      else
        parent_slug = Skill.find_by_id(self.parent_id).slug
        
        title_slug = self.title.gsub(/[\s\/\\]+/,'-').chomp('-')
        
        if parent_slug != '' 
          parent_slug += '/'
        end
        
        title_slug = parent_slug + title_slug.downcase.gsub(/[^a-z0-9\-]/,'')
        
        generated_slug = title_slug
        
        i = 1
        while Skill.find_by_slug(generated_slug)
          generated_slug = "#{title_slug}-#{i}"
          i += 1
        end  
        
        self.slug = generated_slug
      end
    end
end
