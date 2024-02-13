defmodule TrelloWebApiWeb.ListJSON do
  alias TrelloWebApi.Lists.List

  def index(%{lists: lists}) do
   %{data: for(list <- lists, do: data(list))}
  end

  def show(%{list: list}) do
    %{data: data(list)}
  end

  defp data(%List{} = list) do
    %{
      id: list.id,
      name: list.name,
      board_id: list.board_id
    }
  end
end
