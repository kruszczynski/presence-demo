defmodule Presence.Repo do
  use Ecto.Repo,
    otp_app: :presence,
    adapter: Ecto.Adapters.Postgres
end
