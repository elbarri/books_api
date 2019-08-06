defmodule BooksApi.Repo.Migrations.CreateAuthors do
  use Ecto.Migration

  def change do
    create table(:authors, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :firstname, :string
      add :lastname, :string

      timestamps()
    end

  end
end
