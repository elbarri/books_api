defmodule BooksApiWeb.AuthorController do
  use BooksApiWeb, :controller

  alias BooksApi.Reads
  alias BooksApi.Reads.Author

  action_fallback BooksApiWeb.FallbackController

  plug BasicAuth,
       [
         callback: &BooksApi.Authentication.authenticate/3,
         custom_response: &BooksApi.Authentication.unauthorized_response/1
       ]
       when action not in [:index, :show]

  def index(conn, _params) do
    authors = Reads.list_authors()
    render(conn, "index.json", authors: authors)
  end

  def create(conn, %{"author" => author_params}) do
    cs = Author.changeset(%Author{}, author_params)

    case cs.valid? do
      true ->
        with {:ok, %Author{} = author} <- Reads.create_author(author_params) do
          conn
          |> put_status(:created)
          |> put_resp_header("location", Routes.author_path(conn, :show, author))
          |> render("show.json", author: author)
        end

      false ->
        send_resp(conn, :bad_request, "Invalid Request Body")
    end
  end

  def show(conn, %{"id" => id}) do
    author = Reads.get_author!(id)
    render(conn, "show.json", author: author)
  end

  def update(conn, %{"id" => id, "author" => author_params}) do
    author = Reads.get_author!(id)

    with {:ok, %Author{} = author} <- Reads.update_author(author, author_params) do
      render(conn, "show.json", author: author)
    end
  end

  def delete(conn, %{"id" => id}) do
    author = Reads.get_author!(id)

    with {:ok, %Author{}} <- Reads.delete_author(author) do
      send_resp(conn, :no_content, "")
    end
  end
end
