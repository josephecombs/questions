-- TOTAL LIKES FOR A USER
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
                            author_id = 1))
  AS FLOAT) / (
    SELECT
      COUNT(*)
    FROM
      questions
    WHERE
      author_id = 1
  );
  
