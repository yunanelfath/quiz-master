class CreateQuizzes < ActiveRecord::Migration
  def change
    create_table :quizzes do |t|
      t.integer :user_id
      t.integer :question_id
      t.string :answer

      t.timestamps null: false
    end
    add_index :quizzes, :question_id
    add_index :quizzes, :user_id
    add_index :quizzes, :answer

    add_foreign_key :quizzes, :users, column: :user_id
    add_foreign_key :quizzes, :questions, column: :question_id
  end
end
