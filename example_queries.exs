import Ecto.Query
alias Ecto.Adapters.SQL
alias GladiatorPlane.Repo
alias GladiatorPlane.User

users_to_insert =
  [
    [
      username: "IronFlipFlops",
      email: "nickthorpe71@gmail.com",
      inserted_at: DateTime.utc_now(),
      updated_at: DateTime.utc_now(),
    ]
  ]

Repo.insert_all "users", users_to_insert, returning: [:id, :username]
