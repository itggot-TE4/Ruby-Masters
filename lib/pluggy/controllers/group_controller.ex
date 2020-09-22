defmodule Pluggy.GroupController do
  defstruct(groupname: "", id: nil)
  require IEx

  alias Pluggy.Fruit
  alias Pluggy.User
  alias Pluggy.Group
  alias Pluggy.School
  import Pluggy.Template, only: [render: 2, srender: 2]
  import Plug.Conn, only: [send_resp: 3]
  import Pluggy.FaceController
  alias Pluggy.FaceController

  def edit(conn) do
    data = Group.edit_get(conn)
    username = conn.private.plug_session["user"].username
    send_resp(conn, 200, srender("admin/schools", [username: username, data: data, name: "123"]))
  end

  def index(conn) do
    username = conn.private.plug_session["user"].username
    group_data = Group.get(conn)
    IO.inspect(group_data)
    send_resp(conn, 200, srender("admin/group", [username: username, data: group_data]))
  end

  def create(conn) do
    IO.inspect(conn)
    redirect(conn, "/admin/school/1")
  end

  defp redirect(conn, url),
    do: Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
end
