defmodule Pluggy.Router do
  use Plug.Router
  use Plug.Debugger


  alias Pluggy.FruitController
  alias Pluggy.UserController
  alias Pluggy.FaceController
  alias Pluggy.SchoolController
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

  # get("/fruits", do: FruitController.index(conn))
  # get("/fruits/new", do: FruitController.new(conn))
  # get("/fruits/:id", do: FruitController.show(conn, id))
  # get("/fruits/:id/edit", do: FruitController.edit(conn, id))

  # post("/fruits", do: FruitController.create(conn, conn.body_params))

  # # should be put /fruits/:id, but put/patch/delete are not supported without hidden inputs
  # post("/fruits/:id/edit", do: FruitController.update(conn, id, conn.body_params))

  # # should be delete /fruits/:id, but put/patch/delete are not supported without hidden inputs
  # post("/fruits/:id/destroy", do: FruitController.destroy(conn, id))

  # post("/users/login", do: UserController.login(conn, conn.body_params))
  # post("/users/logout", do: UserController.logout(conn))

  get("/", do: FaceController.index(conn))

  get("/user/login", do: send_resp(conn, 200, srender("users/new", conn: conn)))
  post("/user/login", do: UserController.login(conn, conn.body_params))
  post("/user/logout", do: UserController.logout(conn))

  get("/school/index", do: SchoolController.show(conn))

  get("/admin/groups", do: send_resp(conn, 200, srender("admin/schools", [username: conn.private.plug_session["user"].username, name: "123"])))
  post("/school/new", do: SchoolController.create(conn, conn.body_params))

  get("/teacher/class", do: send_resp(conn, 200, srender("partials/teacher_group", conn: conn)))
  get("/class/id", do: send_resp(conn, 200, srender("partials/admin_group", conn: conn)))

  get("/school/class", do: send_resp(conn, 200, srender("partials/teacher_group", conn: conn)))
  post("/school/destroy", do: SchoolController.destroy(conn, conn.body_params))


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
