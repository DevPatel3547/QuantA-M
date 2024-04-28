class GeneralController < ApplicationController
  def help
    @user_faqs = [
      { question: 'Finding Activities', answer: 'general/help_answers/finding_activities' },
      { question: 'Signing Up for Activities', answer: 'general/help_answers/signing_up_for_activities' },
      { question: 'Verifying Your Attendance', answer: 'general/help_answers/verifying_your_attendance' },
      { question: 'Finding an Article', answer: 'general/help_answers/finding_an_article' },
      { question: 'Viewing Your Profile', answer: 'general/help_answers/viewing_your_profile' },
      { question: 'Viewing Your Points', answer: 'general/help_answers/viewing_your_points' },
    ]

    @officer_faqs = [
      { question: 'Creating an Activity', answer: 'general/help_answers/creating_an_activity' }
    ]
  end
end
