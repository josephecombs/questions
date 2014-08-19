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
  
  def initialize(id, body, question_id, parent_reply_id, author_id)
    @id = result["id"] 
    @body = result["body"]
    @question_id = result["question_id"]
    @parent_reply_id = result["parent_reply_id"]
    @author_id = result["author_id"]
  end
end