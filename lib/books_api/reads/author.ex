defmodule BooksApi.Reads.Author do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "authors" do
    field :firstname, :string
    field :lastname, :string
    has_many :books, BooksApi.Reads.Book

    timestamps()
  end

  @doc false
  def changeset(author, attrs) do
    author
    |> cast(attrs, [:firstname, :lastname])
    |> validate_required([:firstname, :lastname])
  end
end
