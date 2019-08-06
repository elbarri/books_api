defmodule BooksApi.Permissions do
  @moduledoc """
  The Permissions context.
  """

  import Ecto.Query, warn: false
  alias BooksApi.Repo

  alias BooksApi.Permissions.User
  alias BooksApi.Permissions.Method

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def valid_credentials?(username, password) do
    Repo.exists?(from u in User, where: u.username == ^username and u.password == ^password)
  end

  def has_access?(username, method, function) do
    Repo.exists?(
      from u in User,
        join: m in Method,
        where:
          u.username == ^username and u.id == m.user_id and
            m.function == ^function and m.method == ^method
    )
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  alias BooksApi.Permissions.Method

  @doc """
  Returns the list of methods.

  ## Examples

      iex> list_methods()
      [%Method{}, ...]

  """
  def list_methods do
    Repo.all(Method)
  end

  @doc """
  Gets a single method.

  Raises `Ecto.NoResultsError` if the Method does not exist.

  ## Examples

      iex> get_method!(123)
      %Method{}

      iex> get_method!(456)
      ** (Ecto.NoResultsError)

  """
  def get_method!(id), do: Repo.get!(Method, id)

  @doc """
  Creates a method.

  ## Examples

      iex> create_method(%{field: value})
      {:ok, %Method{}}

      iex> create_method(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_method(attrs \\ %{}) do
    %Method{}
    |> Method.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a method.

  ## Examples

      iex> update_method(method, %{field: new_value})
      {:ok, %Method{}}

      iex> update_method(method, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_method(%Method{} = method, attrs) do
    method
    |> Method.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Method.

  ## Examples

      iex> delete_method(method)
      {:ok, %Method{}}

      iex> delete_method(method)
      {:error, %Ecto.Changeset{}}

  """
  def delete_method(%Method{} = method) do
    Repo.delete(method)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking method changes.

  ## Examples

      iex> change_method(method)
      %Ecto.Changeset{source: %Method{}}

  """
  def change_method(%Method{} = method) do
    Method.changeset(method, %{})
  end
end
