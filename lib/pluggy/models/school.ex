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



end
