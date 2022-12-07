PRAGMA foreign_keys = ON;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255),
  lname VARCHAR(255)

);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body VARCHAR(255),
  user_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY(question_id) REFERENCES questions(id),
  FOREIGN KEY(user_id) REFERENCES users(id)

);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  reply TEXT NOT NULL,
  parent_reply_id INTEGER,
  question INTEGER NOT NULL,
  user INTEGER NOT NULL,


  FOREIGN KEY (question) REFERENCES questions(id),
  FOREIGN KEY (user) REFERENCES users(id),
  FOREIGN KEY (parent_reply_id) REFERENCES replies(id)

);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  likes BOOLEAN,
  question INTEGER NOT NULL,
  user INTEGER NOT NULL,

  FOREIGN KEY (question) REFERENCES questions(id),
  FOREIGN KEY (user) REFERENCES users(id)
);

INSERT INTO
  users(fname, lname)
VALUES
  ('Luis', 'Perez'),
  ('Janira', 'Crispin'),
  ('Bob', 'Ross'),
  ('Mei', 'Huang');

INSERT INTO
  questions(title, body,user_id)
VALUES

  ('Do fish fart?', 'I was just wondering', (SELECT id FROM users WHERE fname = 'Janira')),
  ('Why the laptop broke?', 'I see buttons and keys missing', (SELECT id FROM users WHERE fname = 'Luis')),
  ('Wheres my coffee?', 'Make sure its not black', (SELECT id FROM users WHERE fname = 'Mei'));

INSERT INTO 
  replies(reply, parent_reply_id, question, user)
VALUES 

  ('No', NULL, (SELECT id FROM questions WHERE title = 'Do fish fart?'), (SELECT id FROM users WHERE fname = 'Bob')),
  ('Wait they do', (SELECT id FROM replies WHERE reply LIKE 'N%'), (SELECT id FROM questions WHERE title = 'Do fish fart?'), (SELECT id FROM users WHERE fname = 'Bob'));
  
  INSERT INTO 
    question_likes(likes, question, user)
  VALUES

    (true, (SELECT id FROM questions WHERE title LIKE 'Why%'), (SELECT id FROM users WHERE fname = 'Luis'));




