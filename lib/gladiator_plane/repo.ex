defmodule GladiatorPlane.Repo do
  use Ecto.Repo,
    otp_app: :gladiator_plane,
    adapter: Ecto.Adapters.Postgres
end
