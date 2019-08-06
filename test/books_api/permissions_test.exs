defmodule BooksApi.PermissionsTest do
  use BooksApi.DataCase

  alias BooksApi.Permissions
  alias BooksApi.TestHelper

  describe "users" do
    alias BooksApi.Permissions.User

    @valid_attrs %{password: "some password", username: "some username"}
    @update_attrs %{password: "some updated password", username: "some updated username"}
    @invalid_attrs %{password: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Permissions.create_user()

      user
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Permissions.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Permissions.create_user(@valid_attrs)
      assert user.password == "some password"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Permissions.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Permissions.update_user(user, @update_attrs)
      assert user.password == "some updated password"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Permissions.update_user(user, @invalid_attrs)
      assert user == Permissions.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Permissions.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Permissions.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Permissions.change_user(user)
    end
  end

  describe "methods" do
    alias BooksApi.Permissions.Method

    @valid_attrs %{function: "some function", method: "some method"}
    @update_attrs %{function: "some updated function", method: "some updated method"}
    @invalid_attrs %{function: nil, method: nil, user_id: nil}

    setup do
      {:ok, user} = TestHelper.create_user(%{username: "facundo", password: "pwd1"})
      {:ok, new_user} = TestHelper.create_user(%{username: "tom", password: "pwd2"})

      [initial_user: user.id, new_user: new_user.id]
    end

    def method_fixture(attrs \\ %{}) do
      {:ok, method} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Permissions.create_method()

      method
    end

    test "get_method!/1 returns the method with given id", context do
      method = method_fixture(%{user_id: context[:initial_user]})
      assert Permissions.get_method!(method.id) == method
    end

    test "create_method/1 with valid data creates a method", context do
      attrs =
        %{user_id: context[:initial_user]}
        |> Enum.into(@valid_attrs)

      assert {:ok, %Method{} = method} = Permissions.create_method(attrs)
      assert method.function == "some function"
      assert method.method == "some method"
      assert method.user_id == context[:initial_user]
    end

    test "create_method/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Permissions.create_method(@invalid_attrs)
    end

    test "update_method/2 with valid data updates the method", context do
      method = method_fixture(%{user_id: context[:initial_user]})

      new_attrs =
        %{user_id: context[:new_user]}
        |> Enum.into(@update_attrs)

      assert {:ok, %Method{} = method} = Permissions.update_method(method, new_attrs)
      assert method.function == "some updated function"
      assert method.method == "some updated method"
      assert method.user_id == context[:new_user]
    end

    test "update_method/2 with invalid data returns error changeset", context do
      method = method_fixture(%{user_id: context[:initial_user]})
      assert {:error, %Ecto.Changeset{}} = Permissions.update_method(method, @invalid_attrs)
      assert method == Permissions.get_method!(method.id)
    end

    test "delete_method/1 deletes the method", context do
      method = method_fixture(%{user_id: context[:initial_user]})
      assert {:ok, %Method{}} = Permissions.delete_method(method)
      assert_raise Ecto.NoResultsError, fn -> Permissions.get_method!(method.id) end
    end

    test "change_method/1 returns a method changeset", context do
      method = method_fixture(%{user_id: context[:initial_user]})
      assert %Ecto.Changeset{} = Permissions.change_method(method)
    end
  end
end
