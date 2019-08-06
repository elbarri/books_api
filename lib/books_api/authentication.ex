defmodule BooksApi.Authentication do
  import Plug.Conn

  alias BooksApi.Permissions

  def authenticate(conn, username, password) do
    Permissions.valid_credentials?(username, password)
    |> after_auth(username, conn)
  end

  def after_auth(false, _, conn), do: halt(put_status(conn, :unauthorized))

  def after_auth(_authenticated, username, conn) do
    # TODO Way of obtaining function is rather ugly. Re-think.
    if !Permissions.has_access?(username, conn.method, Enum.at(conn.path_info, 1)) do
      halt(put_status(conn, :forbidden))
    else
      conn
    end
  end

  # Custom response
  def unauthorized_response(conn = %{halted: true}), do: pipe_conn(conn, conn.status)

  def unauthorized_response(conn), do: pipe_conn(conn, :unauthorized)

  defp pipe_conn(conn, status) do
    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> Plug.Conn.send_resp(status, ~s[{"message": "Unauthorized"}])
  end
end
