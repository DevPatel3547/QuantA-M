require 'rails_helper'

RSpec.describe "Article", type: :system do
    before do
      driven_by(:rack_test)
    end
  
    include_context 'logged in user'
  
    scenario 'User views the five most recent articles on the welcome page' do
      create_list(:article, 10)
  
      visit root_path
  
      recent_articles = Article.order(created_at: :desc).limit(5)

      recent_articles.each do |article|
        expect(page).to have_content(article.title)
      end
    end

    scenario 'User views the welcome page with fewer than 5 recent articles available' do
      create_list(:article, 3)
    
      visit root_path
    
      available_articles = Article.order(created_at: :desc)
    
      available_articles.each do |article|
        expect(page).to have_content(article.title)
      end
    end
      
      
  
    scenario 'User views the five most recent and upcoming activities on the welcome page' do
        create_list(:activity, 10) 
      
        visit root_path
      
        recent_and_upcoming_activities = Activity.where('start_time >= ?', Time.zone.now)
                                                  .where('start_time <= ?', Time.zone.now + 7.days)
                                                  .order(start_time: :desc)
                                                  .limit(5)
      
        recent_and_upcoming_activities.each do |activity|
          expect(page).to have_content(activity.title)
        end
      end


      scenario 'Less than 5 most recent activities' do
        create_list(:activity, 3) # Create some sample activities
      
        visit root_path
      
        # Fetch the five most recent and upcoming activities directly from the database
        recent_and_upcoming_activities = Activity.where('start_time >= ?', Time.zone.now)
                                                  .where('start_time <= ?', Time.zone.now + 7.days)
                                                  .order(start_time: :desc)
                            
      
        # Check if each recent or upcoming activity's title is present on the page
        recent_and_upcoming_activities.each do |activity|
          expect(page).to have_content(activity.title)
        end
      end


      
  
  end
  