defmodule BooksApi.TestHelper do
  alias BooksApi.Repo
  alias BooksApi.Reads.Author
  alias BooksApi.Permissions.User

  def create_author(%{firstname: firstname, lastname: lastname}) do
    Author.changeset(%Author{}, %{firstname: firstname, lastname: lastname})
    |> Repo.insert()
  end

  def create_user(%{username: username, password: password}) do
    User.changeset(%User{}, %{username: username, password: password})
    |> Repo.insert()
  end
end
