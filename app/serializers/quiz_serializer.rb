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

class QuizSerializer < ApplicationSerializer
  attributes(
    :id,
    :user_id,
    :question_id,
    :answer,
    :answered,
    :result,
    :content,
    :created_at
  )

  def created_at
    object.created_at.to_formatted_s(:long)
  end

  def content
    object.question.try(:content)
  end

  def include_content?
    include_attribute?(:content, default: false)
  end

  def answered
    "Answer by #{object.user.email} on Quiz mode: #{object.answer.to_i.to_words} (#{object.try(:answer).to_i})"
  end

  def include_answered?
   include_attribute?(:answered, default: false)
  end

  def result
    if object.try(:answer).to_i == object.question.try(:answer).to_i
      true
    else
      false
    end
  end

  def include_result?
   include_attribute?(:result, default: false)
  end
end
