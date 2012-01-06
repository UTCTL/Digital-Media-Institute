module LessonsHelper
  VIMEO_REGEX = /^http:\/\/(?:www\.)?vimeo\.com\/([0-9]+)$/
  YOUTUBE_REGEX = /^http:\/\/(?:www\.)?youtube\.com\/watch\?(?=.*v=(\w+))(?:\S+)?$/
  
  def player_link(link)
    
    if matches = link.match(VIMEO_REGEX)
      return "http://player.vimeo.com/video/#{matches[1]}?title=0&amp;byline=0&amp;portrait=0"
    end
    
    if matches = link.match(YOUTUBE_REGEX)
      return "http://www.youtube.com/embed/#{matches[1]}"
    end
    
    return nil
  end
end
