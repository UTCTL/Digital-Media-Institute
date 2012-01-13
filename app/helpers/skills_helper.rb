module SkillsHelper
  
  def print_tree_cols(tree)
    output = ""
    right_values = []
    
    close_tags = ['','</ul></div>','</div>','</li>']

    tree.each do |node|
       if(right_values.length > 0)

         while(right_values.last < node.right)
           right_values.pop
           
           output += close_tags[right_values.length]
         end
          
       end 
      
      if(right_values.length == 3)
        output += <<-HTML
          <li id="tree-#{node.id}" class="tree_node">
        HTML
        
        output += link_to( node.title, training_path(node.slug))
      
      elsif(right_values.length == 2) 
        output += <<-HTML
          <div id="tree-#{node.id}" class="tree_node">
            <span class="second_level">#{h(node.title)}</span>
            <ul>
        HTML
      elsif(right_values.length == 1)
        
        output += <<-HTML
          <div id="tree-#{node.id}" class="skill_tree toplevel_node">
            <span class="top_level">#{h(node.title)}</span>
        HTML
      end
      
      right_values.push(node.right)
    end

      
    while(right_values.length > 0)
       right_values.pop
    
       output += close_tags[right_values.length]
    end
    

    output.html_safe
  end
  
  def print_tree_list(tree,current)
    output = ""
    right_values = []

    tree.each do |node|
       if(right_values.length > 0)

         while(right_values.last < node.right)
           right_values.pop
           
           if right_values.length > 0
             output += "</ul></li>" 
           else
             output += "</ul>"
           end
         end
          
       end 
      
      if(node != tree.first)
        
        headings = ['',"top_level","second_level"]
        
        if(right_values.length == 3)
          link_class = (node.id == current.id) ? "current" : ""
          node_text = link_to(node.title,training_path(node.slug), :class => link_class)
        else
          node_text = content_tag(:span, node.title, :class => headings[right_values.length])
        end
        
        output += <<-HTML
                  <li>#{node_text}
                    <ul>
                  HTML
      else
        output += "<ul class=\"skill_tree\">"
      end
            
      
      right_values.push(node.right)
    end

      
      while(right_values.length > 0)
        right_values.pop

        if right_values.length > 0
          output += "</ul></li>" 
        else
          output += "</ul>"
      end
    end
    

    output.html_safe
  end
  
  def skill_content_display
    actions = %w(new create)
    type = ""
    
    if(params[:controller] == "skills")
      type = "skillstart"
    end
    
    if(params[:controller] == "lessons" && actions.include?(params[:action]))
      type = "newlesson"
    end
    
    if(params[:controller] == "challenges" && actions.include?(params[:action]))
      type = "newchallenge"
    end
    
    type
  end
  
  def fulltitle
    if @skill
      @skill.fulltitle.gsub(Skill::SEP," \u27A2 ")
    end
  end
  
  def short_title
    if @skill
      index = @skill.fulltitle.index(Skill::SEP)
      short_title = @skill.fulltitle[ (index+Skill::SEP.length)..@skill.fulltitle.length ]
      
      short_title.gsub(Skill::SEP," \u27A2 ")
    end
  end
end
