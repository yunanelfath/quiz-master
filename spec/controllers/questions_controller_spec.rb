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

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe QuestionsController do

  let!(:user) { create(:user)}
  let!(:question) { create(:question, content: "How many people?") }

  before :each do
    @user = user
    @question = question

    sign_in @user
  end

  describe "GET index" do
    it 'correctly @questions' do
      get :index, {}
      expect(response).to have_http_status(200)
      expect(assigns(:questions).to_a).to eq [@question]
    end
  end

  describe "GET #new" do
    it "assigns a new question as @question" do
      get :new, params: {}
      expect(response).to have_http_status(200)
      expect(assigns(:question)).to be_a_new(Question)
    end
  end

end
