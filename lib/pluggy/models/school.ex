defmodule Pluggy.School do
  defstruct(id: nil, name: "")

  alias Pluggy.School

  def create(conn,params)do
    name = params["name"]
    user_id = conn.private.plug_session["user"].id
    school = Postgrex.query!(DB, "INSERT INTO schools(name) VALUES($1) RETURNING id;", [name],pool: DBConnection.ConnectionPool).rows |> to_struct
    Postgrex.query!(DB, "INSERT INTO user_school_handler(user_id, school_id) VALUES($1, $2)", [user_id, school.id], pool: DBConnection.ConnectionPool)

  end


  def to_struct([[id]]) do
    %School{id: id}
  end

  def to_struct([[id, name]]) do
    %School{id: id, name: name}
  end

  def to_struct([id, name]) do
    %School{id: id, name: name}
  end

  def get_from_teacher(user_id) do
    Enum.map(Postgrex.query!(DB, "SELECT school_id, b.name FROM user_school_handler AS a INNER JOIN schools AS b ON b.id = a.school_id INNER JOIN users AS u ON a.user_id = u.id WHERE u.id = $1;", [user_id], pool: DBConnection.ConnectionPool).rows, fn(school) ->
      to_struct(school)
    end)
  end

  def get_from_admin() do
    Enum.map(Postgrex.query!(DB, "SELECT * FROM schools;", [], pool: DBConnection.ConnectionPool).rows, fn(school) ->
      to_struct(school)
    end)
  end
end
