defmodule Pluggy.ApplicationController do
  require IEx

  alias Pluggy.Fruit
  alias Pluggy.User
  alias Pluggy.School
  alias Pluggy.Student
  alias Pluggy.ApplicationController
  import Pluggy.Template, only: [render: 2, srender: 2]
  import Plug.Conn, only: [send_resp: 3]

  def go_back([elm | rest]) do
    [key | value] = Tuple.to_list(elm)
    if key == "referer" do
      [link | _] = value
      link
    else
      go_back(rest)
    end
  end

  def redirect(conn, url),
    do: Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
end
