defmodule BooksApiWeb.BookController do
  use BooksApiWeb, :controller

  alias BooksApi.Reads
  alias BooksApi.Reads.Book

  action_fallback BooksApiWeb.FallbackController

  plug BasicAuth,
       [
         callback: &BooksApi.Authentication.authenticate/3,
         custom_response: &BooksApi.Authentication.unauthorized_response/1
       ]
       when action not in [:index, :show]

  def index(conn, _params) do
    books = Reads.list_books()
    render(conn, "index.json", books: books)
  end

  def create(conn, %{"book" => book_params}) do
    cs = Book.changeset(%Book{}, book_params)

    case cs.valid? do
      true ->
        with {:ok, %Book{} = book} <- Reads.create_book(book_params) do
          conn
          |> put_status(:created)
          |> put_resp_header("location", Routes.book_path(conn, :show, book))
          |> render("show.json", book: book)
        end

      false ->
        send_resp(conn, :bad_request, "Invalid Request Body")
    end
  end

  def show(conn, %{"id" => id}) do
    book = Reads.get_book!(id)
    render(conn, "show.json", book: book)
  end

  def update(conn, %{"id" => id, "book" => book_params}) do
    book = Reads.get_book!(id)

    with {:ok, %Book{} = book} <- Reads.update_book(book, book_params) do
      render(conn, "show.json", book: book)
    end
  end

  def delete(conn, %{"id" => id}) do
    book = Reads.get_book!(id)

    with {:ok, %Book{}} <- Reads.delete_book(book) do
      send_resp(conn, :no_content, "")
    end
  end
end
