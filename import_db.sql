CREATE TABLE users(
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions(
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body VARCHAR(255),
  author_id INTEGER NOT NULL,
  
  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_followers (
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE question_likes (
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id) 
  
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body VARCHAR(255) NOT NULL,
  question_id INTEGER NOT NULL,
  parent_reply_id INTEGER,
  author_id INTEGER NOT NULL,
  
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_reply_id) REFERENCES replies(id),
  FOREIGN KEY (author_id) REFERENCES users(id)
);

-- SEED
INSERT INTO
  users (id, fname, lname)
VALUES
  (1, "Christian", "Moniz"), (2, "Joe", "Combs"), (3, "Will", "Hastings");
  
INSERT INTO
  questions (id, title, body, author_id)
VALUES
  (1, "Does this work?", "Just checking to see if this works...", 1),
  (2, "What is the meaning of life?", "42", 2),
  (3, "Did you finish you work today?", "If not, where did you leave off?", 3),
  (4, "I think it's working...", "Can anybody verify?", 1);
  
INSERT INTO
  question_followers (user_id, question_id)
VALUES
  (1, 2), (1, 3), (2, 1), (2, 3), (2, 4), (3, 4);
  
INSERT INTO
  question_likes (user_id, question_id)
VALUES
  (1, 2), (2, 2), (3, 2), (3, 1), (2, 4);

INSERT INTO
  replies (id, body, question_id, parent_reply_id, author_id)
VALUES
  (1, "Yes, I think it's working!", 1, NULL, 2),
  (2, "Thanks for the reply", 1, 1, 1),
  (3, "I think that's from a book...or something.", 2, NULL, 3),
  (4, "YES WILL I DID", 3, NULL, 1),
  (5, "^", 3, 4, 2),
  (6, "Okay.", 3, 5, 3);