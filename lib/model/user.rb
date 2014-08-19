require_relative 'questions_database'

class User
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
  
  attr_accessor :fname, :lname
  
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
    result = QuestionsDatabase.instance.execute(<<-SQL, @id, @id)
      SELECT
        CAST((SELECT 
                COUNT(*) total_likes
              FROM
                question_likes
              INNER JOIN 
                users
              ON 
                question_likes.user_id = users.id
              WHERE 
                question_id IN (SELECT
                                  questions.id
                                FROM
                                  questions
                                WHERE
                                  author_id = ?))
        AS FLOAT) / (
          SELECT
            COUNT(*)
          FROM
            questions
          WHERE
            author_id = ?
        ) as average_karma;
    SQL
    
    result.first["average_karma"]
  end
end