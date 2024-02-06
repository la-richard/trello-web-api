defmodule TrelloWebApi.Accounts.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :trello_web_api,
    error_handler: TrelloWebApi.Accounts.ErrorHandler,
    module: TrelloWebApi.Accounts.Guardian

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource, allow_blank: true
end
