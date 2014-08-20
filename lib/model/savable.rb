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
    ivs = ivs_sans_id
    columns = ivs_to_strings(ivs)
    values = ivs_to_values(ivs)
    
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
    ivs = ivs_sans_id
    columns = ivs_to_strings(ivs).map { |iv| "#{ iv } = ?" }
    values = ivs_to_values(ivs)
    
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
  
  def ivs_sans_id
    self.instance_variables - [:@id]
  end
  
  def ivs_to_strings(ivs)
    ivs.map { |iv| iv[1..-1] }
  end
  
  def ivs_to_values(ivs)
    ivs.map { |iv| self.instance_variable_get(iv) }
  end
end