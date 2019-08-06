defmodule BooksApiWeb.BookControllerTest do
  use BooksApiWeb.ConnCase

  alias BooksApi.Reads
  alias BooksApi.Reads.Book
  alias BooksApi.TestHelper

  @create_attrs %{
    description: "some description",
    name: "some name"
  }
  @update_attrs %{
    description: "some updated description",
    name: "some updated name"
  }
  @invalid_attrs %{description: nil, name: nil, author_id: nil}

  def fixture(attrs \\ %{}) do
    {:ok, book} =
      attrs
      |> Enum.into(@create_attrs)
      |> Reads.create_book()

    book
  end

  setup %{conn: conn} do
    {:ok, initial_author} = TestHelper.create_author(%{firstname: "initial", lastname: "author"})
    {:ok, new_author} = TestHelper.create_author(%{firstname: "new", lastname: "author"})

    conn = put_req_header(conn, "authorization", "Basic " <> Base.encode64("admin:pwd"))
    conn = put_req_header(conn, "accept", "application/json")
    [conn: conn, initial_author: initial_author.id, new_author: new_author.id]
  end

  describe "index" do
    test "lists all books", %{conn: conn} do
      delete_req_header(conn, "authorization")
      conn = get(conn, Routes.book_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create book" do
    test "renders book when data is valid", %{conn: conn, initial_author: initial_author} do
      attrs = Enum.into(%{author_id: initial_author}, @create_attrs)
      conn = post(conn, Routes.book_path(conn, :create), book: attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.book_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some description",
               "name" => "some name",
               "author_id" => initial_author
             } = json_response(conn, 200)["data"]
    end

    test "return error when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.book_path(conn, :create), book: @invalid_attrs)
      assert response(conn, 400)
    end
  end

  describe "update book" do
    setup [:create_book]

    test "renders book when data is valid", %{
      conn: conn,
      new_author: new_author,
      book: %Book{id: id} = book
    } do
      attrs = Enum.into(%{author_id: new_author}, @update_attrs)

      conn = put(conn, Routes.book_path(conn, :update, book), book: attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.book_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some updated description",
               "name" => "some updated name",
               "author_id" => new_author
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, book: book} do
      conn = put(conn, Routes.book_path(conn, :update, book), book: @invalid_attrs)
      assert json_response(conn, 400)["errors"] != %{}
    end
  end

  describe "delete book" do
    setup [:create_book]

    test "deletes chosen book", %{conn: conn, book: book} do
      conn = delete(conn, Routes.book_path(conn, :delete, book))
      assert response(conn, 204)

      assert_error_sent 410, fn ->
        get(conn, Routes.book_path(conn, :show, book))
      end
    end

    test "DELETE / without basic auth credentials prevents access", %{conn: conn, book: book} do
      conn = delete_req_header(conn, "authorization")
      conn = delete(conn, Routes.book_path(conn, :delete, book))

      assert response(conn, 401)
    end
  end

  defp create_book(%{initial_author: initial_author}) do
    book = fixture(%{author_id: initial_author})
    {:ok, book: book}
  end
end
