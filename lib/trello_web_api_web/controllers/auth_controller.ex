defmodule TrelloWebApiWeb.AuthController do
  use TrelloWebApiWeb, :controller

  alias TrelloWebApi.{Accounts, Accounts.Guardian}

  action_fallback TrelloWebApiWeb.FallbackController

  def login(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        {:ok, token, _full_claims} = Guardian.encode_and_sign(user, %{}, ttl: {60, :minutes})
        conn
        |> put_view(json: TrelloWebApiWeb.UserJSON)
        |> render(:login, user: user, token: token)
      {:error, :invalid_credentials} ->
        conn
        |> put_status(403)
        |> put_view(json: TrelloWebApiWeb.ErrorJSON)
        |> render(:"403")
    end
  end
end
