defmodule Pluggy.FaceController do
  require IEx

  alias Pluggy.Fruit
  alias Pluggy.User
  alias Pluggy.School
  import Pluggy.Template, only: [render: 2, srender: 2]
  import Plug.Conn, only: [send_resp: 3]

  def index(conn) do
    # get user if logged in
    session_user = conn.private.plug_session["user"]


    case session_user do
      nil -> redirect(conn, "/user/login")
      _ -> nil
    end

    if session_user.status == "admin" do
      teachers = User.get_teachers()

      schools = School.get_from_admin()
      send_resp(conn, 200, srender("admin/index", [schools: schools,teachers: teachers, username: conn.private.plug_session["user"].username]))
    else
      schools = School.get_from_teacher(session_user.id)
      send_resp(conn, 200, srender("teacher/index", [schools: schools, username: conn.private.plug_session["user"].username]))
    end
  end

  defp redirect(conn, url),
    do: Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
end
