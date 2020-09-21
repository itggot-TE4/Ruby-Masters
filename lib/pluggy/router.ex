defmodule Pluggy.Router do
  use Plug.Router
  use Plug.Debugger


  alias Pluggy.FruitController
  alias Pluggy.UserController
  alias Pluggy.FaceController
  alias Pluggy.SchoolController
  alias Pluggy.GroupController
  import Pluggy.Template, only: [render: 2, srender: 2]


  plug(Plug.Static, at: "/", from: :pluggy)
  plug(:put_secret_key_base)

  plug(Plug.Session,
    store: :cookie,
    key: "_pluggy_session",
    encryption_salt: "cookie store encryption salt",
    signing_salt: "cookie store signing salt",
    key_length: 64,
    log: :debug,
    secret_key_base: "-- LONG STRING WITH AT LEAST 64 BYTES -- LONG STRING WITH AT LEAST 64 BYTES --"
  )

  plug(:fetch_session)
  plug(Plug.Parsers, parsers: [:urlencoded, :multipart])
  plug(:match)
  plug(:dispatch)

  get("/", do: FaceController.index(conn))

  get("/user/login", do: send_resp(conn, 200, srender("users/new", conn: conn)))
  post("/user/login", do: UserController.login(conn, conn.body_params))
  post("/user/logout", do: UserController.logout(conn))

  get("/school/index", do: SchoolController.show(conn))

  get("/admin/school/:id", do: GroupController.edit(conn))
  post("/school/new", do: SchoolController.create(conn, conn.body_params))

  post("/user/new", do: UserController.create(conn, conn.body_params))

  get("/teacher/class", do: send_resp(conn, 200, srender("partials/teacher_group", conn: conn)))
  get("/class/id", do: send_resp(conn, 200, srender("partials/admin_group", conn: conn)))
  get("/admin/groups/1", do: send_resp(conn, 200, srender("partials/teacher_image", conn: conn)))


  get("/school/class", do: send_resp(conn, 200, srender("partials/teacher_group", conn: conn)))
  post("/school/destroy", do: SchoolController.destroy(conn, conn.body_params))

  get("/admin/group/:id", do: GroupController.index(conn))

  post("/group/create", do: GroupController.create(conn))

  match _ do
    send_resp(conn, 404, "oops")
  end

  defp put_secret_key_base(conn, _) do
    put_in(
      conn.secret_key_base,
      "-- LONG STRING WITH AT LEAST 64 BYTES LONG STRING WITH AT LEAST 64 BYTES --"
    )
  end
end
