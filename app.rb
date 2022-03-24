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
    db = SQLite3::Database.new("db/database.db")
    db.results_as_hash = true
    result = db.execute("SELECT * FROM book")
    p result
    slim(:"affar/new",locals:{books:result})
  end
  
get('/affar/new') do 
  slim(:"affar/new")
end
  
post('/affar/new') do
    book_name = params[:book_name]
    book_id = params[:book_id].to_i
    book_price = params[:book_price].to_f
    book_img = params[:book_img]
    book_stock = params[:book_stock].to_i
    db = SQLite3::Database.new("db/database.db")
    db.results_as_hash = true
    db.execute("INSERT INTO book (Name, id, Price, Stock, img ) VALUES (?,?,?,?,?)",book_name,book_id,book_price,book_stock,book_img)
    redirect('/affar/new')
    
   
end

post('/affar/new/:book_id/update') do
  book_id = params[:book_id].to_i
  book_name = params[:book_name]
  db = SQLite3::Database.new("db/database.db")
  db.execute("UPDATE book SET Name=? WHERE id = ?",book_name,book_id)
  redirect('/affar/new')
end


get('/affar/new/:book_id/edit') do
  book_id = params[:book_id].to_i
  db = SQLite3::Database.new("db/database.db")
  db.results_as_hash = true
  result = db.execute("SELECT * FROM book WHERE id = ?",book_id).first
  slim(:"/affar/edit", locals:{result:result})
end





