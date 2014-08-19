require_relative 'questions_database'

class Question
  # id INTEGER PRIMARY KEY,
  #  title VARCHAR(255) NOT NULL,
  #  body VARCHAR(255),
  #  author_id INTEGER NOT NULL,
  #
  #  FOREIGN KEY (author_id) REFERENCES users(id)
  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id=?;
    SQL
    
    return nil if result.empty?

    Question.new(result.first)
  end

  def initialize(options)
    @id = options["id"]
    @title = options["title"]
    @body = options ["body"]
    @author_id = options["author_id"]
  end
end