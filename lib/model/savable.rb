module Savable
  def save
    row_exists? ? update_db : insert_into_db
  end
  
  def table_name
    raise NotImplementedError("Savable classes must override table_name")
  end
  
  private
  
  def row_exists?
    @id
  end
  
  def insert_into_db
    ivs = self.instance_variables - [:@id]
    columns = ivs.map { |iv| iv[1..-1] }
    values = ivs.map { |iv| self.instance_variable_get(iv) }
    
    query = <<-SQL
      INSERT INTO
        #{ table_name } (#{ columns.join(',') })
      VALUES
        (#{ values.map { '?' }.join(',') });
    SQL

    QuestionsDatabase.instance.execute(query, *values)
    @id = QuestionsDatabase.instance.last_insert_row_id
  end
  
  def update_db
    ivs = self.instance_variables - [:@id]
    columns = ivs.map { |iv| "#{ iv[1..-1] } = ?" }
    values = ivs.map { |iv| self.instance_variable_get(iv) }
    
    query = <<-SQL
      UPDATE
        #{ table_name }
      SET
        #{ columns.join(',') }
      WHERE
        id = #{@id};
    SQL

    QuestionsDatabase.instance.execute(query, *values)
  end
end
