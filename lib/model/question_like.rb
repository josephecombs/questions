require_relative 'questions_database'

class QuestionLike
  # user_id INTEGER NOT NULL,
  # question_id INTEGER NOT NULL,
  #
  # FOREIGN KEY (user_id) REFERENCES users(id),
  # FOREIGN KEY (question_id) REFERENCES questions(id)
  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT 
        *
      FROM
        question_likes
      WHERE 
        id = ?;
    SQL
    
    return nil if result.empty?
    
    QuestionLike.new(result.first)
  end
  
  def initialize(options)
    @user_id = options["user_id"]
    @question_id = options["question_id"]
  end
end