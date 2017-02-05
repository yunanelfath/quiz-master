require 'rails_helper'

RSpec.describe "questions/new", type: :view do
  before(:each) do
    assign(:question, Question.new(
      :content => "MyText",
      :answer => "MyString"
    ))
  end

  it "renders new question form" do
    render

    assert_select "form[action=?][method=?]", questions_path, "post" do

      assert_select "textarea#question_content[name=?]", "question[content]"

      assert_select "input#question_answer[name=?]", "question[answer]"
    end
  end
end
