defmodule TrelloWebApi.ListsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TrelloWebApi.Lists` context.
  """

  @doc """
  Generate a list.
  """
  def list_fixture(attrs \\ %{}) do
    {:ok, list} =
      attrs
      |> Enum.into(%{
        name: "some name",
        rank: "some rank"
      })
      |> TrelloWebApi.Lists.create_list()

    list
  end
end
