require 'sinatra'
require 'slim'
require 'sqlite3'
enable :sessions

def connect_to_db(path)
    db = SQLite3::Database.new(path)
    db.results_as_hash = true
    return db
end


get('/') do      
    slim(:start)
end


get('/affar') do
    db = SQLite3::Database.new("db/database.db")
    db.results_as_hash = true
    result = db.execute("SELECT * FROM Book")
    p result
    slim(:"affar/index",locals:{book:result})
  
  
  
  end




