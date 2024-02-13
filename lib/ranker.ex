defmodule Ranker do
  import Ecto.Query, warn: false
  alias TrelloWebApi.Repo

  def new(schema) do
    highest_rank = Repo.one(from(s in schema, order_by: [desc: s.rank], limit: 1))

    if highest_rank, do: get_next_unique_rank(schema, increment_rank(highest_rank.rank)), else: "5000"
  end

  def reorder(schema, prev_id, next_id) do
    prev = if prev_id, do: Repo.get(schema, prev_id), else: nil
    next = if next_id, do: Repo.get(schema, next_id), else: nil

    rank_reorder(schema, prev, next)
  end

  defp rank_reorder(schema, nil, next) do
    get_prev_unique_rank(schema, next.rank)
  end

  defp rank_reorder(schema, prev, nil) do
    get_next_unique_rank(schema, prev.rank)
  end

  defp rank_reorder(schema, prev, next) do
    previous_rank = String.to_integer(prev.rank)
    next_rank = String.to_integer(next.rank)
    distance = abs(next_rank - previous_rank)
    new_rank = to_string(previous_rank + div(distance, 2))

    get_next_unique_rank(schema, new_rank)
  end

  defp get_next_unique_rank(schema, rank) do
    task = Repo.one(from(s in schema, where: s.rank == ^rank))

    if task, do: get_next_unique_rank(schema, increment_rank(rank, 5)), else: rank
  end

  defp increment_rank(rank, step \\ 100) do
    to_string(String.to_integer(rank) + step)
  end

  defp get_prev_unique_rank(schema, rank) do
    task = Repo.one(from(s in schema, where: s.rank == ^rank))

    if task, do: get_prev_unique_rank(schema, decrement_rank(rank, 5)), else: rank
  end

  defp decrement_rank(rank, step) do
    to_string(String.to_integer(rank) - step)
  end
end
