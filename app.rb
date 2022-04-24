require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'
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
    result = db.execute("SELECT * FROM book")
    result2 = db.execute("SELECT * FROM genre")
    p (result)
    slim(:"affar/index",locals:{books:result,genres:result2})
  end

get('/affar/kategori/:genre_id/:genre_name') do 
  genre_id = params[:genre_id].to_i
  db = SQLite3::Database.new("db/database.db")
  db.results_as_hash = true
  result = db.execute("SELECT * FROM Genre WHERE id =?",genre_id).first
  result2 = db.execute("SELECT Name FROM book_genre_rel INNER JOIN book ON book_genre_rel.book_id = book.id WHERE genre_id = ?",genre_id)
  print (result2)
  slim(:"affar/show2",locals:{result:result,result2:result2})
end

get('/affar/new') do
  if (session[:role] !=  1)
    session[:error] = "You need to log in to see this"
    redirect("/")
  else
    db = SQLite3::Database.new("db/database.db")
    db.results_as_hash = true
    result = db.execute("SELECT * FROM book")
    p result
    slim(:"affar/new",locals:{books:result})
  end
end



  
post('/affar/new') do
    book_name = params[:book_name]
    book_price = params[:book_price].to_f
    book_img = params[:book_img]
    book_stock = params[:book_stock].to_i
    db = SQLite3::Database.new("db/database.db")
    db.results_as_hash = true
    db.execute("INSERT INTO book (Name, Price, Stock, img ) VALUES (?,?,?,?)",book_name,book_price,book_stock,book_img)
    redirect('/affar/new')
    
   
end

post('/affar/:book_id/update') do
  book_id = params[:book_id].to_i
  book_stock = params[:book_stock]
  book_name = params[:book_name]
  book_price = params[:book_price].to_f
  book_img = params[:book_img]
  db = SQLite3::Database.new("db/database.db")
  db.execute("UPDATE book SET Stock=?, img=?, Price=?, Name=? WHERE id = ?",book_stock,book_img,book_price,book_name,book_id)
  redirect('/affar/new')
end

post('/affar/new/:id/delete') do 
  id = params[:id].to_i
  db = SQLite3::Database.new("db/database.db")
  db.execute("DELETE FROM book WHERE id = ?",id)
  redirect('/affar/new')
end


get('/affar/new/:book_id/edit') do
  book_id = params[:book_id].to_i
  db = SQLite3::Database.new("db/database.db")
  db.results_as_hash = true
  result = db.execute("SELECT * FROM book WHERE id = ?",book_id).first
  slim(:"/affar/edit", locals:{result:result})
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
  role = result["role"]
 
  role =
  if BCrypt::Password.new(pwdigest) == password
    session[:id] = id
    session[:role] = role
    redirect('/user')
  else
    "FEL LÖSENORD NOOB!"
  end
end


get('/user') do
  id = session[:id].to_i
  db = SQLite3::Database.new("db/database.db")
  db.results_as_hash = true
  result = db.execute("SELECT * FROM users WHERE id = ? ",id).first
  p (result)
  slim(:"/user/index",locals:{users:result})
end


get('/affar/:book_id/book') do
  book_id = params[:book_id].to_i
  db = SQLite3::Database.new("db/database.db")
  db.results_as_hash = true
  result = db.execute("SELECT * FROM book WHERE id = ?",book_id).first
  
  slim(:"affar/show",locals:{result:result})
end

post('/affar/:book_id/bought') do
  book_id = params[:book_id].to_i
  db = SQLite3::Database.new("db/database.db")
  db.execute("UPDATE book SET Stock = Stock - 1 WHERE id = ?",book_id)
  redirect('/affar')
end
