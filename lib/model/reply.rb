require_relative 'questions_database'

class Reply
  attr_accessor :body, :question_id, :parent_reply_id, :author_id

  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?;
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
        question_id = ?;
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
        author_id = ?;
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
        parent_reply_id = ?;
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
  
  def save
    reply_exists? ? update_db : insert_into_db
  end
  
  private
  def reply_exists?
    Reply.find_by_id(@id) != nil
  end
  
  def insert_into_db
    query = <<-SQL
      INSERT INTO
        replies (body, question_id, parent_reply_id, author_id)
      VALUES
        (?, ?, ?, ?);
    SQL

    QuestionsDatabase.instance.execute(query, @body, @question_id, 
      @parent_reply_id, @author_id)
      
    @id = QuestionsDatabase.instance.last_insert_row_id  
  end
  
  def update_db
    query = <<-SQL
      UPDATE 
        replies
      SET
        body = ?,
        question_id = ?,
        parent_reply_id = ?,
        author_id = ?
      WHERE
        id = ?;
    SQL

    QuestionsDatabase.instance.execute(query, @body, @question_id,
      @parent_reply_id, @author_id, @id)
  end
end