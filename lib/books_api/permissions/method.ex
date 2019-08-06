defmodule BooksApi.Permissions.Method do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "methods" do
    field :function, :string
    field :method, :string
    belongs_to :user, BooksApi.Permissions.User

    timestamps()
  end

  @doc false
  def changeset(method, attrs) do
    method
    |> cast(attrs, [:function, :method, :user_id])
    |> validate_required([:function, :method, :user_id])
    |> foreign_key_constraint(:user_id)
    |> unique_constraint(:method, name: :index_methods_on_users)
  end
end
