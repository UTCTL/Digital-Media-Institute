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
        
        output += link_to( node.title, "#{skills_path}/#{node.slug}")
      
      elsif(right_values.length == 2) 
        output += <<-HTML
          <div id="tree-#{node.id}" class="tree_node">
            <h3>#{h(node.title)}</h3>
            <ul>
        HTML
      elsif(right_values.length == 1)
        
        output += <<-HTML
          <div id="tree-#{node.id}" class="skill_tree toplevel_node">
            <h2>#{h(node.title)}</h2>
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
  
  def print_tree_list(tree)
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
        
        headings = ['',:h2,:h3]
        
        if(right_values.length == 3)
          node_text = link_to(node.title,"#{skills_path}/#{node.slug}")
        else
          node_text = content_tag(headings[right_values.length], node.title)
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
end
