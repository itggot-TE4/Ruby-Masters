defmodule Pluggy.Group do
  defstruct(id: nil, name: "")
  require IEx

  alias Pluggy.Fruit
  alias Pluggy.Student
  alias Pluggy.User
  alias Pluggy.Group
  alias Pluggy.School
  import Pluggy.Template, only: [render: 2, srender: 2]
  import Plug.Conn, only: [send_resp: 3]

  def edit_get(conn) do
    id = String.to_integer(conn.path_params["id"])
    # IO.inspect("123")

    data = Postgrex.query!(DB, "SELECT * FROM schools AS s INNER JOIN groups AS g ON g.school_id = s.id WHERE g.school_id = $1;",[id], pool: DBConnection.ConnectionPool).rows
    [head | _] = data
    [school_id | [school_name | _]] = head

    groups = Enum.map(data, fn(group) ->
      [_ | [_ | [group_id | [group_name | _]]]] = group
      to_struct([group_id, group_name])
    end)

    # IO.inspect(groups)
    # IO.inspect(school_id)
    # IO.inspect(group_data)

    School.to_struct(school_id, school_name, groups)
  end

  def get(conn) do
    id = String.to_integer(conn.path_params["id"])
    student_data = Postgrex.query!(DB, "SELECT students.*, groups.name FROM student_group_handler INNER JOIN groups ON groups.id = group_id INNER JOIN students ON students.id = student_id WHERE group_id = $1;", [id], pool: DBConnection.ConnectionPool).rows

    [[school_id, school_name, group_name, group_id]] = Postgrex.query!(DB, "SELECT schools.id, schools.name, groups.name, groups.id FROM schools INNER JOIN groups ON groups.school_id = schools.id WHERE groups.id = $1;", [id], pool: DBConnection.ConnectionPool).rows
    student_list = Enum.map(student_data, fn(student) ->
      Student.to_struct(student)
    end)

    %{group_name: group_name, school_id: school_id, school_name: school_name, students: student_list, group_id: group_id}
  end
  def to_struct([id, name]) do
    %Group{id: id, name: name}
  end
end
