require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'
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

post('/affar/:book_id/update') do
  book_id = params[:book_id].to_i
  book_stock = params[:book_stock]
  db = SQLite3::Database.new("db/database.db")
  db.execute("UPDATE book SET Stock=? WHERE id = ?",book_stock,book_id)
  redirect('/affar/new')
end


get('/affar/new/:book_id/edit') do
  book_id = params[:book_id].to_i
  db = SQLite3::Database.new("db/database.db")
  db.results_as_hash = true
  result = db.execute("SELECT * FROM book WHERE id = ?",book_id).first
  slim(:"/affar/edit", locals:{result:result})
end

get('/affar/:book_id/book') do
  db = SQLite3::Database.new("db/database.db")
  db.results_as_hash = true
  result = db.execute("SELECT * FROM book")
  p result
  slim(:"affar/book",locals:{books:result})
end

get('/register') do 
  slim(:"/register")
end


get('/showlogin') do 
  slim(:"/login")
end


post('/users/new') do 
  username = params[:username]
  password = params[:password]
  password_confirm = params[:password_confirm]

  if (password == password_confirm)
    password_digest = BCrypt::Password.create(password)
    db = SQLite3::Database.new("db/database.db")
    db.execute("INSERT INTO users (username,password) VALUES (?,?)",username,password_digest)
    redirect('/')

  else
    "Lösenorderen matchade inte!!!!!!"
  end
end


post('/Login') do
  username = params[:username]
  password = params[:password]
  db = SQLite3::Database.new("db/database.db")
  db.results_as_hash = true
  result = db.execute("SELECT * FROM users WHERE username = ?",username).first
  pwdigest = result["password"]
  id = result["id"]
  if BCrypt::Password.new(pwdigest) == password
    session[:id] = id
    redirect('/user')
  else
    "FEL LÖSENORD NOOB!"
  end
end



get('/user') do
  id = session[:id].to_i
  db = SQLite3::Database.new("db/database.db")
  db.results_as_hash = true
  result = db.execute("SELECT * users WHERE user_id = ? ",id)
  p (result)
  slim(:"user/index",locals{users:result})
end
