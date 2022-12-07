require 'singleton'
require 'sqlite3'

class QuestionsDatabase < SQLite3::Database
include Singleton

    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end 
end 

class Users

    attr_accessor :fname, :lname, :id

    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end 

    def self.all
        data = QuestionsDatabase.instance.execute('SELECT * FROM users')
        data.map { |datum| Users.new(datum)}
    end 

    def self.find_by_id(id)
        id_found = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT 
            * 
        FROM 
            users
        WHERE id = ?
        SQL
        return nil unless id_found.length > 0
        User.new(id_found.first) 
    end 

    def create
        raise '#{self} already in database' if @id 
        QuestionsDatabase.instance.execute(<<-SQL, @fname, @lname)
        INSERT INTO
            users (fname, lname)
        VALUES
            (?, ?)
        SQL
        @id = QuestionsDatabase.instance.last_insert_row_id
    end 

    def update 
        raise '#{self} not in database' unless id 
        QuestionsDatabase.instance.execute(<<-SQL, @fname, @lname, @id)
            UPDATE
                users
            SET
                fname = ?, lname = ?
            WHERE
                id = ?
        SQL
    end 
end 

class Question

    attr_accessor :id, :title, :body, :user_id
    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @user_id = options['user_id']
    end 

    def self.all
        data = QuestionsDatabase.instance.execute('SELECT * FROM questions')
        data.map { |datum| Question.new(datum)}
    end 
    
    def self.find_by_id(id)
        id_found = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT 
            * 
        FROM 
            questions
        WHERE id = ?
        SQL
        return nil unless id_found.length > 0
        Question.new(id_found.first) 
    end 

    def create
        raise '#{self} already in database' if @id 
        QuestionsDatabase.instance.execute(<<-SQL, @title, @body, @user_id)
        INSERT INTO
            users (title, body, user_id)
        VALUES
            (?, ?, ?)
        SQL
        @id = QuestionsDatabase.instance.last_insert_row_id
    end 

    def update 
        raise '#{self} not in database' unless id 
        QuestionsDatabase.instance.execute(<<-SQL, @title, @body, @user_id, @id)
            UPDATE
                questions
            SET
                title = ?, body = ?, user_id = ?
            WHERE
                id = ?
        SQL
    end 
end 

class Reply

    attr_accessor :id, :reply, :parent_reply_id, :question, :user
    def initialize(options)
        @id = options['id']
        @reply = options['reply']
        @parent_reply_id = options['parent_reply_id']
        @question = options['question']
        @user = options['user']
    end 

    def self.all
        data = QuestionsDatabase.instance.execute('SELECT * FROM replies')
        data.map { |datum| Reply.new(datum)}
    end 
    
    def self.find_by_id(id)
        id_found = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT 
            * 
        FROM 
            replies
        WHERE id = ?
        SQL
        return nil unless id_found.length > 0
        Reply.new(id_found.first) 
    end 


    def create
        raise '#{self} already in database' if @id 
        QuestionsDatabase.instance.execute(<<-SQL, @reply, @parent_reply_id, @question, @user)
        INSERT INTO
            replies (reply, parent_reply_id, question, user)
        VALUES
            (?, ?, ?, ?)
        SQL
        @id = QuestionsDatabase.instance.last_insert_row_id
    end 

    def update 
        raise '#{self} not in database' unless id 
        QuestionsDatabase.instance.execute(<<-SQL, @reply, @parent_reply_id, @question, @user, @id)
            UPDATE
                replies
            SET
                reply = ?, parent_reply_id = ?, question = ?, user = ?
            WHERE
                id = ?
        SQL
    end 
end 

class Like

    attr_accessor :id, :like, :question, :user
    def initialize(options)
        @id = options['id']
        @like = options['likes']
        @question = options['question']
        @user = options['user']
    end 

    def self.all
        data = QuestionsDatabase.instance.execute('SELECT * FROM question_likes')
        data.map { |datum| Like.new(datum)}
    end 
    
    def self.find_by_id(id)
        id_found = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT 
            * 
        FROM 
            question_likes
        WHERE id = ?
        SQL
        return nil unless id_found.length > 0
        Like.new(id_found.first) 
    end 


    def create
        raise '#{self} already in database' if @id 
        QuestionsDatabase.instance.execute(<<-SQL, @like, @question, @user)
        INSERT INTO
            questions_likes (likes, question, user)
        VALUES
            (?, ?, ?)
        SQL
        @id = QuestionsDatabase.instance.last_insert_row_id
    end 

    def update 
        raise '#{self} not in database' unless id 
        QuestionsDatabase.instance.execute(<<-SQL, @like, @question, @user, @id)
            UPDATE
                question_likes
            SET
                likes = ?, question = ?, user = ?
            WHERE
                id = ?
        SQL
    end 
end 