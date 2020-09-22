defmodule Pluggy.Student do
  defstruct(id: nil, name: "", img: "")

  require IEx

  alias Pluggy.Student
  alias Pluggy.Fruit
  alias Pluggy.User
  alias Pluggy.Group
  alias Pluggy.School
  import Pluggy.Template, only: [render: 2, srender: 2]
  import Plug.Conn, only: [send_resp: 3]

  def to_struct([id, name, img, _]) do
    %Student{id: id, name: name, img: img}
  end

  def destroy(conn) do
    id = String.to_integer(conn.params["id"])
    Postgrex.query!(DB, "DELETE FROM students WHERE id = $1;", [id], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DELETE FROM student_group_handler WHERE student_id = $1;", [id], pool: DBConnection.ConnectionPool)
  end
end
