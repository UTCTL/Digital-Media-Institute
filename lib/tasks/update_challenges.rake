namespace :db do
  desc "Change Organization of challenges to the new format"
  task :update_challenges => :environment do
    skill_challenges = SkillChallenge.where(:parent_id => nil).includes(:challenge)

    skill_challenges.each do |sc|
      title = sc.challenge.title || "Test"
      new_root = SkillChallenge.create!(:skill_id => sc.skill_id, :title => title)
      sc.move_to_child_of(new_root)

      sc.descendants.each do |child|
        child.move_to_child_of(new_root)
      end


    end
  end
end
