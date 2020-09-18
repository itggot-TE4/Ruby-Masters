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

    Postgrex.query!(DB, "INSERT INTO users (name, status, pwd) VALUES($1, $2, $ 3)", [username, "teacher", pwd], pool: DBConnection.ConnectionPool)

  end

  def to_struct([[id, name]]) do
    %User{id: id, username: name}
  end

  def to_struct([[id, username, pwd, status]]) do
    %User{id: id, username: username, pwd: pwd, status: status}
  end
end
