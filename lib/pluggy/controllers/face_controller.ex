defmodule Pluggy.FaceController do
  require IEx

  alias Pluggy.Fruit
  alias Pluggy.User
  import Pluggy.Template, only: [render: 2, srender: 2]
  import Plug.Conn, only: [send_resp: 3]

  def index(conn) do
    # get user if logged in
    session_user = conn.private.plug_session["user_id"]


    case session_user do
      nil -> redirect(conn, "/user/login")
      _ -> nil
    end

    send_resp(conn, 200, srender("whats_their_face/index", []))
  end

  defp redirect(conn, url),
    do: Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
end
