defmodule BooksApi.Reads.Book do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "books" do
    field :description, :string
    field :name, :string
    belongs_to :author, BooksApi.Reads.Author

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:name, :description, :author_id])
    |> validate_required([:name, :description, :author_id])
    |> foreign_key_constraint(:author_id)
  end
end
