defmodule BooksApi.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :string
      add :author_id, references(:authors, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:books, [:author_id])
  end
end
