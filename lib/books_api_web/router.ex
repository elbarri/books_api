defmodule BooksApiWeb.Router do
  use BooksApiWeb, :router
  use Plug.ErrorHandler

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BooksApiWeb do
    pipe_through :api
    resources "/authors", AuthorController, except: [:new, :edit]
    resources "/books", BookController, except: [:new, :edit]
  end

  def handle_errors(conn, _err = %{kind: :error, reason: %DBConnection.ConnectionError{}}) do
    send_resp(conn, 503, "Database DOWN")
  end

  def handle_errors(conn, _err = %{kind: :error, reason: %Ecto.NoResultsError{}}) do
    send_resp(conn, 410, "Resource not found")
  end

  def handle_errors(conn, _err = %{kind: :error, reason: %Phoenix.ActionClauseError{}}) do
    send_resp(conn, 400, "Check your response body entity")
  end

  def handle_errors(conn, _err = %{kind: _kind, reason: _reason}) do
    conn
  end
end
