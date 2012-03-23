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
  
  has_many :skill_challenges do
    def categories

      # this awesome query joins the category skill_challenge with the first child skill_challenge
      # this was refactored fromt the old method of arranging challenges where there
      # was a primary challenge and sub challenges.  This should probably be changed to flatten
      # the list and add the category as a field on each row

      SkillChallenge.find_by_sql([ "SELECT x.*,a.challenge_id AS first_child
                                    FROM skill_challenges x 
                                    JOIN (SELECT y.parent_id, MIN(y.lft) AS min_lft 
                                          FROM skill_challenges y 
                                          WHERE y.parent_id IS NOT NULL 
                                          GROUP BY y.parent_id) z 
                                          ON x.id = z.parent_id 
                                          JOIN (SELECT lft,challenge_id 
                                                FROM skill_challenges 
                                                WHERE challenge_id IS NOT NULL
                                                AND skill_id = ?) a 
                                          ON z.min_lft = a.lft 
                                          WHERE x.skill_id = ? 
                                          ORDER BY x.lft",
                                  proxy_association.owner.id,proxy_association.owner.id])


    end
  end
  has_many :challenges, :through => :skill_challenges
  
  has_many :skill_lessons

  # the app was originally designed with lessons and other resources as the same resource
  # lessons are list scope 1 and reources are list scope 2. I have since taken
  # Other Resources out of the UI, but the functionality is still here

  has_many :lessons, :through => :skill_lessons do
    def list_scope(num)
      Lesson.joins(:skill_lessons)
            .where("skill_id = ? AND list_scope = ?", proxy_association.owner.id, num)
            .order('position')
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
