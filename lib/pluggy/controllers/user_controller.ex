defmodule Pluggy.UserController do
  # import Pluggy.Template, only: [render: 2] #det här exemplet renderar inga templates
  import Plug.Conn, only: [send_resp: 3]
  require IEx

  alias Pluggy.Fruit
  alias Pluggy.User
  import Pluggy.Template, only: [render: 2, srender: 2]
  import Plug.Conn, only: [send_resp: 3]


  # def login(conn, params) do
  #   username = params["username"]
  #   password = params["pwd"]

  #    #Bör antagligen flytta SQL-anropet till user-model (t.ex User.find)
  #   result =
  #     Postgrex.query!(DB, "SELECT id, password_hash FROM users WHERE username = $1", [username],
  #       pool: DBConnection.ConnectionPool
  #     )

  #   case result.num_rows do
  #     # no user with that username
  #     0 ->
  #       redirect(conn, "/fruits")
  #     # user with that username exists
  #     _ ->
  #       [[id, password_hash]] = result.rows

  #       # make sure password is correct
  #       if Bcrypt.verify_pass(password, password_hash) do
  #         Plug.Conn.put_session(conn, :user_id, id)
  #         |> redirect("/fruits") #skicka vidare modifierad conn
  #       else
  #         redirect(conn, "/fruits")
  #       end
  #   end
  # end

  def login(conn, params) do

    username = params["username"]
    pwd = params["password"]
    user = User.get_by_username(username)

    


    if Bcrypt.verify_pass(pwd, user.pwd) do
      Plug.Conn.put_session(conn, :user, user) |> redirect("/")
    else
      Plug.Conn.put_session(conn, :incorrect_login_info, true) |> redirect("/user/login")
    end

  end


  def logout(conn) do
    Plug.Conn.configure_session(conn, drop: true) #tömmer sessionen
    |> redirect("/")
  end

  def remove(conn, params) do
    
  end

  def create(conn, params) do
    User.create(conn, params)
    redirect(conn, "/")
  end
  # def create(conn, params) do
  # 	#pseudocode
  # 	# in db table users with password_hash CHAR(60)
  # 	# hashed_password = Bcrypt.hash_pwd_salt(params["password"])
  #  	# Postgrex.query!(DB, "INSERT INTO users (username, password_hash) VALUES ($1, $2)", [params["username"], hashed_password], [pool: DBConnection.ConnectionPool])
  #  	# redirect(conn, "/fruits")
  # end

   def redirect(conn, url),
     do: Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
end
