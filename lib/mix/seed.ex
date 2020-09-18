defmodule Mix.Tasks.Seed do
  use Mix.Task

  @shortdoc "Resets & seeds the DB."
  def run(_) do
    Mix.Task.run "app.start"
    drop_tables()
    create_tables()
    seed_data()
  end

  defp drop_tables() do
    IO.puts("Dropping tables")
    Postgrex.query!(DB, "DROP TABLE IF EXISTS users", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS groups", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS schools", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS students", [], pool: DBConnection.ConnectionPool)

    Postgrex.query!(DB, "DROP TABLE IF EXISTS student_group_handler", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS user_school_handler", [], pool: DBConnection.ConnectionPool)
  end

  defp create_tables() do
    IO.puts("Creating tables")
    Postgrex.query!(DB, "Create TABLE users (id SERIAL, name VARCHAR(255) NOT NULL UNIQUE, pwd VARCHAR(255) NOT NULL, status VARCHAR(255) NOT NULL)", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "Create TABLE groups (id SERIAL, name VARCHAR(255) NOT NULL, school_id INTEGER NOT NULL )", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "Create TABLE schools (id SERIAL, name VARCHAR(255) NOT NULL)", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "Create TABLE students (id SERIAL, name VARCHAR(255) NOT NULL, img VARCHAR(255))", [], pool: DBConnection.ConnectionPool)

    Postgrex.query!(DB, "Create TABLE student_group_handler (student_id INTEGER NOT NULL, group_id INTEGER NOT NULL)", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "Create TABLE user_school_handler (user_id INTEGER NOT NULL, school_id INTEGER NOT NULL)", [], pool: DBConnection.ConnectionPool)
  end

  defp seed_data() do
    IO.puts("Seeding data")

    Postgrex.query!(DB, "INSERT INTO users(name, status, pwd) VALUES($1, $2, $3)", ["Admin", "admin", "123"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO users(name, status, pwd) VALUES($1, $2, $3)", ["Filip", "teacher", "hej"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO users(name, status, pwd) VALUES($1, $2, $3)", ["Alex", "teacher", "hej"], pool: DBConnection.ConnectionPool)

    Postgrex.query!(DB, "INSERT INTO groups(name, school_id) VALUES($1, $2)", ["TE4", 1], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO groups(name, school_id) VALUES($1, $2)", ["TE3", 1], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO groups(name, school_id) VALUES($1, $2)", ["TE2", 1], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO groups(name, school_id) VALUES($1, $2)", ["TE17K", 2], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO groups(name, school_id) VALUES($1, $2)", ["TE18K", 2], pool: DBConnection.ConnectionPool)

    Postgrex.query!(DB, "INSERT INTO schools(name) VALUES($1)", ["NTI"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO schools(name) VALUES($1)", ["Elof"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO schools(name) VALUES($1)", ["Nåtrandom"], pool: DBConnection.ConnectionPool)

    Postgrex.query!(DB, "INSERT INTO students(name, img) VALUES($1, $2)", ["Steffe Skarsgård", "steffe.img"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO students(name, img) VALUES($1, $2)", ["Brad Pitt", "brad.img"], pool: DBConnection.ConnectionPool)


    Postgrex.query!(DB, "INSERT INTO student_group_handler(student_id, group_id) VALUES($1, $2)", [1, 1], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO student_group_handler(student_id, group_id) VALUES($1, $2)", [2, 1], pool: DBConnection.ConnectionPool)

    Postgrex.query!(DB, "INSERT INTO user_school_handler(user_id, school_id) VALUES($1, $2)", [2, 1], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO user_school_handler(user_id, school_id) VALUES($1, $2)", [3, 3], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO user_school_handler(user_id, school_id) VALUES($1, $2)", [3, 2], pool: DBConnection.ConnectionPool)
  end

end

#join på skola, skol_user_handler och schools: SELECT * FROM user_school_handler AS a INNER JOIN schools AS b ON b.id = a.school_id INNER JOIN users AS u ON a.user_id = u.id;
#Dubble join "SELECT * FROM schools AS a INNER JOIN user_school_handler AS b ON a.id = b.school_id INNER JOIN users AS c ON c.id = a.id"
