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
alias BooksApi.Permissions.User
alias BooksApi.Permissions.Method

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
