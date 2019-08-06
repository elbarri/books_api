defmodule BooksApi.ReadsTest do
  use BooksApi.DataCase

  alias BooksApi.Reads
  alias BooksApi.TestHelper

  describe "authors" do
    alias BooksApi.Reads.Author

    @valid_attrs %{
      firstname: "some firstname",
      lastname: "some lastname"
    }
    @update_attrs %{
      firstname: "some updated firstname",
      lastname: "some updated lastname"
    }
    @invalid_attrs %{firstname: nil, lastname: nil}

    def author_fixture(attrs \\ %{}) do
      {:ok, author} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Reads.create_author()

      author
    end

    test "list_authors/0 returns all authors" do
      author = author_fixture()
      assert Reads.list_authors() == [author]
    end

    test "get_author!/1 returns the author with given id" do
      author = author_fixture()
      assert Reads.get_author!(author.id) == author
    end

    test "create_author/1 with valid data creates a author" do
      assert {:ok, %Author{} = author} = Reads.create_author(@valid_attrs)
      assert author.firstname == "some firstname"
      assert author.lastname == "some lastname"
    end

    test "create_author/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Reads.create_author(@invalid_attrs)
    end

    test "update_author/2 with valid data updates the author" do
      author = author_fixture()
      assert {:ok, %Author{} = author} = Reads.update_author(author, @update_attrs)
      assert author.firstname == "some updated firstname"
      assert author.lastname == "some updated lastname"
    end

    test "update_author/2 with invalid data returns error changeset" do
      author = author_fixture()
      assert {:error, %Ecto.Changeset{}} = Reads.update_author(author, @invalid_attrs)
      assert author == Reads.get_author!(author.id)
    end

    test "delete_author/1 deletes the author" do
      author = author_fixture()
      assert {:ok, %Author{}} = Reads.delete_author(author)
      assert_raise Ecto.NoResultsError, fn -> Reads.get_author!(author.id) end
    end

    test "change_author/1 returns a author changeset" do
      author = author_fixture()
      assert %Ecto.Changeset{} = Reads.change_author(author)
    end
  end

  describe "books" do
    alias BooksApi.Reads.Book

    @valid_attrs %{
      description: "some description",
      name: "some name"
    }
    @update_attrs %{
      description: "some updated description",
      name: "some updated name"
    }
    @invalid_attrs %{description: nil, name: nil, author_id: nil}

    setup do
      {:ok, author} = TestHelper.create_author(%{firstname: "initial", lastname: "author"})
      {:ok, new_author} = TestHelper.create_author(%{firstname: "new", lastname: "author"})

      [initial_author: author.id, new_author: new_author.id]
    end

    def book_fixture(attrs \\ %{}) do
      {:ok, book} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Reads.create_book()

      book
    end

    test "list_books/0 returns all books", context do
      book = book_fixture(%{author_id: context[:initial_author]})
      assert Reads.list_books() == [book]
    end

    test "get_book!/1 returns the book with given id", context do
      book = book_fixture(%{author_id: context[:initial_author]})
      assert Reads.get_book!(book.id) == book
    end

    test "create_book/1 with valid data creates a book", context do
      attrs =
        %{author_id: context[:initial_author]}
        |> Enum.into(@valid_attrs)

      assert {:ok, %Book{} = book} = Reads.create_book(attrs)
      assert book.description == "some description"
      assert book.name == "some name"
      assert book.author_id == context[:initial_author]
    end

    test "create_book/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Reads.create_book(@invalid_attrs)
    end

    test "update_book/2 with valid data updates the book", context do
      book = book_fixture(%{author_id: context[:initial_author]})

      new_attrs =
        %{author_id: context[:new_author]}
        |> Enum.into(@update_attrs)

      assert {:ok, %Book{} = book} = Reads.update_book(book, new_attrs)
      assert book.description == "some updated description"
      assert book.name == "some updated name"
      assert book.author_id == context[:new_author]
    end

    test "update_book/2 with invalid data returns error changeset", context do
      book = book_fixture(%{author_id: context[:initial_author]})
      assert {:error, %Ecto.Changeset{}} = Reads.update_book(book, @invalid_attrs)
      assert book == Reads.get_book!(book.id)
    end

    test "delete_book/1 deletes the book", context do
      book = book_fixture(%{author_id: context[:initial_author]})
      assert {:ok, %Book{}} = Reads.delete_book(book)
      assert_raise Ecto.NoResultsError, fn -> Reads.get_book!(book.id) end
    end

    test "change_book/1 returns a book changeset", context do
      book = book_fixture(%{author_id: context[:initial_author]})
      assert %Ecto.Changeset{} = Reads.change_book(book)
    end
  end
end
