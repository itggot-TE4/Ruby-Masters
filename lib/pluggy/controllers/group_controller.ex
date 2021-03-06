defmodule Pluggy.GroupController do
  defstruct(groupname: "", id: nil)
  require IEx

  alias Pluggy.Fruit
  alias Pluggy.User
  alias Pluggy.Group
  alias Pluggy.School
  alias Pluggy.ApplicationController
  import Pluggy.Template, only: [render: 2, srender: 2]
  import Plug.Conn, only: [send_resp: 3]
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

  def add_student_to_group(conn) do
    User.create_and_add_to_group(conn)
    IO.inspect("#########")
    link = ApplicationController.go_back(conn.req_headers)
    IO.inspect(link)
    ApplicationController.redirect(conn, link)
  end


end
