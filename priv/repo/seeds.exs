# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     BooksApi.Repo.insert!(%BooksApi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias BooksApi.Repo
alias BooksApi.Reads.Author
alias BooksApi.Reads.Book
alias BooksApi.Permissions.User
alias BooksApi.Permissions.Method

Repo.insert!(%Author{
  firstname: "Juan Pablo",
  lastname: "Perez",
  books: [
    %Book{name: "JP #1", description: "Juan Pablo first"},
    %Book{name: "JP #2", description: "Juan Pablo second"},
    %Book{name: "JP #3", description: "Juan Pablo third"}
  ]
})

Repo.insert!(%Author{
  firstname: "Facundo",
  lastname: "Diaz",
  books: [
    %Book{name: "I think, therefore I think", description: "Some-thing"}
  ]
})

Repo.insert!(%Author{firstname: "Robertosin", lastname: "Libros", books: []})

Repo.insert!(%User{
  username: "admin",
  password: "pwd",
  methods: [
    %Method{method: "POST", function: "authors"},
    %Method{method: "PUT", function: "authors"},
    %Method{method: "PATCH", function: "authors"},
    %Method{method: "DELETE", function: "authors"},
    %Method{method: "POST", function: "books"},
    %Method{method: "PUT", function: "books"},
    %Method{method: "PATCH", function: "books"},
    %Method{method: "DELETE", function: "books"}
  ]
})

Repo.insert!(%User{
  username: "booker",
  password: "pwd",
  methods: [
    %Method{method: "POST", function: "books"},
    %Method{method: "DELETE", function: "books"}
  ]
})
