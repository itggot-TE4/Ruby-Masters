defmodule Pluggy.School do
  defstruct(id: nil, name: "", groups: [])

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

  def to_struct([id, name]) do
    %School{id: id, name: name}
  end

  def to_struct([id, name], list) do
    %School{id: id, name: name, groups: list}
  end

  def get_from_teacher(user_id) do
    Postgrex.query!(DB, "SELECT school_id, b.name FROM user_school_handler AS a INNER JOIN schools AS b ON b.id = a.school_id INNER JOIN users AS u ON a.user_id = u.id WHERE u.id = $1;", [user_id], pool: DBConnection.ConnectionPool).rows
      |> Enum.map(fn(school) ->
        [id | _] = school
        list = Postgrex.query!(DB, "SELECT * FROM groups WHERE school_id = $1", [id], pool: DBConnection.ConnectionPool).rows
          |> Enum.map(fn([group_id | [name | _]]) ->
            %{id: group_id, name: name}
          end)

        Postgrex.query!(DB, "SELECT * FROM groups WHERE school_id = $1", [id], pool: DBConnection.ConnectionPool).rows |> IO.inspect()
        to_struct(school, list)
      end)
  end

  def get_from_admin() do
    Enum.map(Postgrex.query!(DB, "SELECT * FROM schools;", [], pool: DBConnection.ConnectionPool).rows, fn(school) ->
      to_struct(school)
    end)
  end

  def destroy(id) do
    Postgrex.query!(DB, "DELETE FROM schools WHERE id = $1", [id], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DELETE FROM user_school_handler WHERE school_id = $1", [id], pool: DBConnection.ConnectionPool)
  end
end
