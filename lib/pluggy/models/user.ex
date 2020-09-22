defmodule Pluggy.User do
  defstruct(id: nil, username: "", status: "", pwd: "")

  alias Pluggy.User

  def get(id) do
    Postgrex.query!(DB, "SELECT id, username FROM users WHERE id = $1 LIMIT 1", [id],
      pool: DBConnection.ConnectionPool
    ).rows
    |> to_struct
  end

  def get_by_username(username) do
    Postgrex.query!(DB, "SELECT * FROM users WHERE name = $1", [username], pool: DBConnection.ConnectionPool).rows
    |> to_struct
  end

  def get_teachers() do
    teachers = Postgrex.query!(DB, "SELECT id, name FROM users WHERE status = $1", ["teacher"], pool: DBConnection.ConnectionPool).rows
    Enum.map(teachers, fn(teacher) -> to_struct([teacher]) end)
  end

  def create(conn, params) do
    username = params["name"]
    pwd = params["pwd"]
    
    Postgrex.query!(DB, "INSERT INTO users (name, status, pwd) VALUES($1, $2, $3);", [username, "teacher", pwd], pool: DBConnection.ConnectionPool).rows

  end

  def create_and_add_to_group(conn) do
    name = conn.params["name"]
    group_id = conn.params["group_id"]
    img = conn.params["img"]

    [[student_id]] = Postgrex.query!(DB, "INSERT INTO students(name, img) VALUES($1, $2) RETURNING id;", [name, img], pool: DBConnection.ConnectionPool).rows
    Postgrex.query!(DB, "INSERT INTO student_group_handler(student_id, group_id) VALUES($1, $2)", [student_id, String.to_integer(group_id)], pool: DBConnection.ConnectionPool)
  end

  def to_struct([[id, name]]) do
    %User{id: id, username: name}
  end

  def to_struct([[id, username, pwd, status]]) do
    %User{id: id, username: username, pwd: pwd, status: status}
  end
end
