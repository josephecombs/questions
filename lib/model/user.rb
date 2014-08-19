require_relative 'questions_database'
require_relative 'savable'

class User
  attr_accessor :fname, :lname

  include Savable
  
  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?;
    SQL
    
    return nil if result.empty?
 
    User.new(result.first)
  end
  
  def self.find_by_name(fname, lname)
    result = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND lname = ?;
    SQL
    
    return nil if result.empty?
 
    User.new(result.first)
  end
  
  def initialize(options)
    @id = options["id"]
    @fname = options["fname"]
    @lname = options["lname"]
  end
    
  def authored_questions
    Question.find_by_author_id(@id)
  end
  
  def authored_replies
    Reply.find_by_author_id(@id)
  end
  
  def followed_questions
    QuestionFollower.followed_questions_for_user_id(@id)
  end
  
  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end
  
  def average_karma
    query = <<-SQL
      SELECT
        CAST(COUNT(question_likes.question_id) AS FLOAT) / 
          COUNT(DISTINCT questions.id) AS average_karma
      FROM
        questions
      LEFT OUTER JOIN
        question_likes
      ON
        questions.id = question_likes.question_id
      WHERE
        questions.author_id = ?;
    SQL
    result = QuestionsDatabase.instance.execute(query, @id)
    result.first["average_karma"]
  end
  
  protected
  def table_name
    "users"
  end
end