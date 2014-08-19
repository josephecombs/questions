require_relative 'questions_database'

class Reply
  # id INTEGER PRIMARY KEY,
  # body VARCHAR(255) NOT NULL,
  # question_id INTEGER NOT NULL,
  # parent_reply_id INTEGER,
  # author_id INTEGER NOT NULL,
  #
  # FOREIGN KEY (question_id) REFERENCES questions(id),
  # FOREIGN KEY (parent_reply_id) REFERENCES replies(id),
  # FOREIGN KEY (author_id) REFERENCES users(id)
  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        id=?;
    SQL
    
    return nil if result.empty?

    Reply.new(result.first)
  end
  
  def self.find_by_question_id(question_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id=?;
    SQL
  
    return nil if result.empty?
 
    result.map { |row| Reply.new(row) }
  end
  
  def self.find_by_author_id(author_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        replies
      WHERE
        author_id=?;
    SQL

    return nil if result.empty?
 
    result.map { |row| Reply.new(row) }
    
  end
  
  def self.find_by_parent_reply_id(parent_reply_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, parent_reply_id)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_reply_id=?;
    SQL

    return nil if result.empty?
 
    result.map { |row| Reply.new(row) }
  end
  
  def initialize(options)
    @id = options["id"] 
    @body = options["body"]
    @question_id = options["question_id"]
    @parent_reply_id = options["parent_reply_id"]
    @author_id = options["author_id"]
  end
  
  def author
    User.find_by_id(@author_id)
  end
  
  def question
    Question.find_by_id(@question_id)
  end
  
  def parent_reply
    return nil if @parent_reply_id.nil?
    Reply.find_by_id(@parent_reply_id)
  end
  
  def child_replies
    Reply.find_by_parent_reply_id(@parent_reply_id)
  end
end