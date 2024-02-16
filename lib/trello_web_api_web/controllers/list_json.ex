defmodule TrelloWebApiWeb.ListJSON do
  alias TrelloWebApiWeb.TaskJSON
  alias TrelloWebApi.Lists.List

  def index(%{lists: lists}, opts \\ []) do
   %{data: for(list <- lists, do: data(list, opts))}
  end

  def show(%{list: list}, opts \\ []) do
    %{data: data(list, opts)}
  end

  defp data(%List{} = list, opts) do
    base_struct = %{
      id: list.id,
      name: list.name,
      board_id: list.board_id
    }

    if Keyword.get(opts, :has_tasks, false) do
      Map.put(base_struct, :tasks, TaskJSON.index(%{tasks: list.tasks}).data)
    else
      base_struct
    end
  end
end
