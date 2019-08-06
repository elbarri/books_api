defmodule BooksApiWeb.AuthorControllerTest do
  use BooksApiWeb.ConnCase

  alias BooksApi.Reads
  alias BooksApi.Reads.Author

  @create_attrs %{
    firstname: "some firstname",
    lastname: "some lastname"
  }
  @update_attrs %{
    firstname: "some updated firstname",
    lastname: "some updated lastname"
  }
  @invalid_attrs %{firstname: nil, lastname: nil}

  def fixture(:author) do
    {:ok, author} = Reads.create_author(@create_attrs)
    author
  end

  setup %{conn: conn} do
    conn = put_req_header(conn, "authorization", "Basic " <> Base.encode64("admin:pwd"))
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all authors", %{conn: conn} do
      delete_req_header(conn, "authorization")
      conn = get(conn, Routes.author_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create author" do
    test "renders author when data is valid", %{conn: conn} do
      conn = post(conn, Routes.author_path(conn, :create), author: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.author_path(conn, :show, id))

      assert %{
               "id" => id,
               "firstname" => "some firstname",
               "lastname" => "some lastname"
             } = json_response(conn, 200)["data"]
    end

    test "return error when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.author_path(conn, :create), author: @invalid_attrs)
      assert response(conn, 400)
    end
  end

  describe "update author" do
    setup [:create_author]

    test "renders author when data is valid", %{conn: conn, author: %Author{id: id} = author} do
      conn = put(conn, Routes.author_path(conn, :update, author), author: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.author_path(conn, :show, id))

      assert %{
               "id" => id,
               "firstname" => "some updated firstname",
               "lastname" => "some updated lastname"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, author: author} do
      conn = put(conn, Routes.author_path(conn, :update, author), author: @invalid_attrs)
      assert json_response(conn, 400) != %{}
    end
  end

  describe "delete author" do
    setup [:create_author]

    test "deletes chosen author", %{conn: conn, author: author} do
      conn = delete(conn, Routes.author_path(conn, :delete, author))
      assert response(conn, 204)

      assert_error_sent 410, fn ->
        get(conn, Routes.author_path(conn, :show, author))
      end
    end

    test "DELETE / without basic auth credentials prevents access", %{conn: conn, author: author} do
      conn = delete_req_header(conn, "authorization")
      conn = delete(conn, Routes.author_path(conn, :delete, author))

      assert response(conn, 401)
    end
  end

  defp create_author(_) do
    author = fixture(:author)
    {:ok, author: author}
  end
end
