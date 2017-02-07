# == Schema Information
#
# Table name: quizzes
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  question_id :integer
#  answer      :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_quizzes_on_answer       (answer)
#  index_quizzes_on_question_id  (question_id)
#  index_quizzes_on_user_id      (user_id)
#

require 'rails_helper'

RSpec.describe "Quizzes", type: :request do
  before :each do
    @user = create(:user)

    login_as @user #http://stackoverflow.com/questions/23859653/rails-devise-rspec-undefined-method-sign-in
  end
  describe "GET /quizzes" do
    it "works! (now write some real specs)" do
      get quizzes_path
      expect(response).to have_http_status(200)
    end
  end
end
