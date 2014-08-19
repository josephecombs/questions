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
  
  def initialize(id, fname, lname)
    @id = result["id"]
    @fname = result["fname"]
    @lname = result["lname"]
  end
end