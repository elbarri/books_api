defmodule BooksApi.Repo.Migrations.CreateMethods do
  use Ecto.Migration

  def change do
    create table(:methods, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :function, :string
      add :method, :string
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create unique_index(:methods, [:user_id, :function, :method], name: :index_methods_on_users)
  end
end
