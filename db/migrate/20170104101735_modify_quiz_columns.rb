class ModifyQuizColumns < ActiveRecord::Migration[5.0]
  def change
    #remove_column :quizzes, :question_name
    #remove_column :quizzes, :option
    add_column :quizzes, :options, :string, array:true, default: []
  end
end