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

FactoryGirl.define do
  factory :quiz do
    user_id 1
    question_id 1
    answer "MyString"
  end
end
