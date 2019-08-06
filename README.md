# BooksApi

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

# Guidelines
Use the Phoenix framework to build an API REST to manage (create, edit, delete) Books and Authors database with Ecto, partial authentication using HTTP auth-basic capabilities against the database, and error management.

#### Database
* MySQL

#### Tables
Books (uuid, name, description)

* Authors (uuid, firstname, lastname)
* N-M relation books and authors
* Users (uuid, username, password)
* Methods (uuid, function, method)
* N-M relation users and methods

#### REST methods to implement (require auth for everything that is not a GET):
* GET
* POST
* PUT
* PATCH
* DELETE

#### Errors/HTTP response codes to handle
* 200: everything went fine
* 201: a POST went fine
* 400: bad request, for example, wrong data sent during a POST
* 401: wrong credentials or credentials needed but not provided
* 403: credentials are correct but user not allowed
* 404: not found
* 410: resource not found, for example after requesting it by doing a GET
* 500: generic error
* 503: database not available