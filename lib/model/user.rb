require_relative 'questions_database'

class User
  # id INTEGER PRIMARY KEY,
  # fname VARCHAR(255) NOT NULL,
  # lname VARCHAR(255) NOT NULL
  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
      users
      WHERE
        id=?;
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
        fname=? AND lname=?;
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
end