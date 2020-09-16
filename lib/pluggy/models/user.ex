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

  def to_struct([[id, username, pwd, status]]) do
    %User{id: id, username: username, pwd: pwd, status: status}
  end
end
