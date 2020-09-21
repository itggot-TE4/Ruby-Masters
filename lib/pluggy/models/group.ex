defmodule Pluggy.Group do
  defstruct(id: nil, name: "")
  require IEx

  alias Pluggy.Fruit
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

  def to_struct([id, name]) do
    %Group{id: id, name: name}
  end
end
