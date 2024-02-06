defmodule TrelloWebApi.Accounts.Guardian do
  use Guardian, otp_app: :trello_web_api

  alias TrelloWebApi.Accounts

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(%{"sub" => id}) do
    user = Accounts.get_user!(id)
    {:ok, user}
  rescue
    Ecto.NoResultsError -> {:error, :not_found}
  end
end
