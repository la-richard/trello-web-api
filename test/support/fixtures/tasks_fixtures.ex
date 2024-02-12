defmodule TrelloWebApi.TasksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TrelloWebApi.Tasks` context.
  """

  @doc """
  Generate a unique task rank.
  """
  def unique_task_rank, do: "some rank#{System.unique_integer([:positive])}"

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        completed: true,
        details: "some details",
        name: "some name",
        rank: unique_task_rank()
      })
      |> TrelloWebApi.Tasks.create_task()

    task
  end
end
