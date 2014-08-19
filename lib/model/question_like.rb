require_relative 'questions_database'

class QuestionLike
  def self.likers_for_question_id(question_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT 
        users.*
      FROM
        question_likes
      INNER JOIN 
        users
      ON 
        users.id = question_likes.user_id
      WHERE 
        question_id = ?;
    SQL
    
    return nil if result.empty?
    
    result.map { |row| User.new(row) }
  end
  
  def self.num_likes_for_question_id(question_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT 
        COUNT(users.id) AS num_likes
      FROM
        question_likes
      INNER JOIN 
        users
      ON 
        question_likes.user_id = users.id
      WHERE 
        question_id = ?;
    SQL
    
    return nil if result.empty?
    
    result.first["num_likes"]
  end
  
  def self.liked_questions_for_user_id(user_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT 
        questions.*
      FROM
        question_likes
      INNER JOIN 
      questions
      ON 
        question_likes.question_id = questions.id
      WHERE 
        user_id = ?;
    SQL
    
    return nil if result.empty?
    
    result.map { |row| Question.new(row) }
  end
  
  def self.most_liked_questions(limit)
    result = QuestionsDatabase.instance.execute(<<-SQL, limit)
      SELECT
        questions.*
      FROM
        question_likes
      INNER JOIN
        questions
      ON
        question_likes.question_id = questions.id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(questions.id) DESC
      LIMIT ?;
    SQL

    return nil if result.empty?

    result.map { |row| Question.new(row) }
  end

  def initialize(options)
    @user_id = options["user_id"]
    @question_id = options["question_id"]
  end
end