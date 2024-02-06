defmodule TrelloWebApi.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TrelloWebApi.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some@email.com",
        password: "some password"
      })
      |> TrelloWebApi.Accounts.create_user()

    user
  end
end
