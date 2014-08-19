require_relative 'questions_database'

class Question
  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?;
    SQL
    
    return nil if result.empty?

    Question.new(result.first)
  end
  
  def self.find_by_author_id(author_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        author_id = ?;
    SQL

    return nil if result.empty?
 
    result.map { |row| Question.new(row) }
  end
  
  def self.most_followed(limit)
    QuestionFollower.most_followed_questions(limit)
  end
  
  def self.most_liked(limit)
    QuestionLike.most_liked_questions(limit)
  end

  def initialize(options)
    @id = options["id"]
    @title = options["title"]
    @body = options["body"]
    @author_id = options["author_id"]
  end
  
  def author
    User.find_by_id(@author_id)
  end
  
  def replies
    Reply.find_by_question_id(@id)
  end
  
  def followers
    QuestionFollower.followers_for_question_id(@id)
  end
  
  def likers
    QuestionLike.likers_for_question_id(@id)
  end
  
  def num_likes
    QuestionLike.num_likes_for_question_id(@id)
  end
end