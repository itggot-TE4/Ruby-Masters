defmodule Pluggy.StudentController do
  require IEx

  alias Pluggy.Fruit
  alias Pluggy.User
  alias Pluggy.School
  alias Pluggy.Student
  alias Pluggy.ApplicationController
  import Pluggy.Template, only: [render: 2, srender: 2]
  import Plug.Conn, only: [send_resp: 3]

  def destroy(conn) do
    Student.destroy(conn)
    ApplicationController.redirect(conn, ApplicationController.go_back(conn.req_headers))
  end
end
