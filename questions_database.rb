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

    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end 

    def self.find_by_id(id)
        id_found = QuestionsDatabase.instance.execute(<<-SQL)
        SQL
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

class Questions

    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @user_id = options['user_id']
    end 

end 