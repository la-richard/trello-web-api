defmodule TrelloWebApi.Repo do
  use Ecto.Repo,
    otp_app: :trello_web_api,
    adapter: Ecto.Adapters.Postgres
end
