defmodule Pluggy.SchoolController do
  require IEx

  alias Pluggy.School
  import Pluggy.Fruit
  alias Pluggy.Fruit
  import Plug.Conn, only: [send_resp: 3]
  def create(conn, params) do
    School.create(conn, params)
    redirect(conn, "/")
  end

  def redirect(conn, url) do
    Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
  end

end
