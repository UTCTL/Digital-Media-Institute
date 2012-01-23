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
#  fulltitle   :string(255)
#

class Skill < ActiveRecord::Base
  acts_as_nested_set
  
  has_many :skill_challenges
  has_many :challenges, :through => :skill_challenges do
    def primary
      Challenge.joins(:skill_challenges).where(:skill_challenges => {:skill_id => proxy_association.owner.id, :parent_id => nil})
    end
  end
  
  has_many :skill_lessons
  has_many :lessons, :through => :skill_lessons do
    def list_scope(num)
      Lesson.joins(:skill_lessons).where("skill_id = ? AND list_scope = ?", proxy_association.owner.id, num)
    end
    
  end
  
  SEP = "|*|"
  
  attr_accessible :title, :description, :icon, :parent_id
  
  validate :only_one_root
  validates :title, :presence => true  
  
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
        parent_skill = Skill.find_by_id(self.parent_id)
        
        parent_slug = parent_skill.slug
        generated_title = parent_skill.fulltitle || ''
        
        generated_slug = self.title.gsub(/[\s\/\\]+/,'-').chomp('-')
        
        if parent_slug != '' 
          parent_slug += '/'
          generated_title += SEP
        end
        
        generated_title += self.title
        generated_slug = parent_slug + generated_slug.downcase.gsub(/[^a-z0-9\-]/,'')
        
        
        i = 1
        while Skill.find_by_slug(generated_slug)
          generated_slug = "#{generated_slug}-#{i}"
          i += 1
        end  
        
        self.fulltitle = generated_title
        self.slug = generated_slug
      end
    end
end
