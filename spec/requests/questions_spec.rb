# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  content    :text
#  answer     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe "Questions", type: :request do
  before :each do
    @user = create(:user)

    login_as @user #http://stackoverflow.com/questions/23859653/rails-devise-rspec-undefined-method-sign-in
  end
  describe "GET /questions" do
    it "works! (now write some real specs)" do
      get questions_path
      expect(response).to have_http_status(200)
    end
  end
end
