defmodule GladiatorPlane.User do
  use Ecto.Schema

  schema "users" do
    field(:about)
    field(:email)
    field(:username)

    timestamps()
  end
end
