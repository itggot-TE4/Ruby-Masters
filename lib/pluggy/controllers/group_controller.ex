defmodule Pluggy.GroupController do
  defstruct(groupname: "", id: nil)
  require IEx

  alias Pluggy.Fruit
  alias Pluggy.User
  alias Pluggy.Group
  alias Pluggy.School
  import Pluggy.Template, only: [render: 2, srender: 2]
  import Plug.Conn, only: [send_resp: 3]

  def edit(conn) do
    data = Group.edit_get(conn)
    username = conn.private.plug_session["user"].username
    send_resp(conn, 200, srender("admin/schools", [username: username, data: data, name: "123"]))
  end


end
