defmodule TrelloWebApi.BoardsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TrelloWebApi.Boards` context.
  """

  @doc """
  Generate a board.
  """
  def board_fixture(attrs \\ %{}) do
    {:ok, board} =
      attrs
      |> Enum.into(%{
        name: "some name",
        visibility: :private
      })
      |> TrelloWebApi.Boards.create_board()

    board
  end

  @doc """
  Generate a board_user.
  """
  def board_user_fixture(attrs \\ %{}) do
    {:ok, board_user} =
      attrs
      |> Enum.into(%{
        permission: :manage
      })
      |> TrelloWebApi.Boards.create_board_user()

    board_user
  end
end
