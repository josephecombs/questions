require_relative 'questions_database'

class QuestionFollower
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
        question_followers
      WHERE 
        id = ?;
    SQL
    
    return nil if result.empty?
    
    QuestionFollower.new(result.first)
  end
  
  def self.followers_for_question_id(question_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT 
        users.*
      FROM
        question_followers
      INNER JOIN 
        users
      ON 
        users.id = question_followers.user_id
      WHERE 
        question_id = ?;
    SQL
    
    return nil if result.empty?
    
    result.map { |row| User.new(row)}
  end
  
  def self.followed_questions_for_user_id(user_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT 
        questions.*
      FROM
        question_followers
      INNER JOIN 
        questions
      ON 
        questions.id = question_followers.question_id
      WHERE 
        user_id = ?;
    SQL
    
    return nil if result.empty?
    
    result.map { |row| Question.new(row)}
  end
  
  def initialize(options)
    @user_id = options["user_id"]
    @question_id = options["question_id"]
  end  
end