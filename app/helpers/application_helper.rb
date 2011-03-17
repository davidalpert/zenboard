module ApplicationHelper  
  def title(page_title)
    content_for(:title) { page_title }
  end
  
  def link_to_story(story)
    story_url = "https://agilezen.com/project/#{story.project.id}/story/#{story.id}"
    link_to(story.id, story_url, :target => "_blank")
  end
  
end
