require 'sinatra'
require 'slim'
require 'sqlite3'
enable :sessions

get('/') do      
    slim(:start)
end


get('/affar') do
    db = SQLite3::Database.new("db/database.db")
    db.results_as_hash = true
    result = db.execute("SELECT * FROM book")
    p result
    slim(:"affar/index",locals:{books:result})
  end



get('/affar/new') do 
  slim(:"affar/new")
end
  
post('/affar/new') do
    book_name = params[:Name]
    book_id = params[:id].to_i
    book_price = params[:Price].to_f
    book_img = params[:img]
    book_stock = params[:Stock].to_i
    db = SQLite3::Database.new("db/database.db")
    db.execute("INSERT INTO book (Name, id, Price, Stock, img ) VALUES (?,?,?,?,?)",book_name,book_id,book_price,book_stock,book_img)
    redirect('/affar/new')
end

