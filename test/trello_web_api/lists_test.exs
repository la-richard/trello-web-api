defmodule TrelloWebApi.ListsTest do
  use TrelloWebApi.DataCase

  alias TrelloWebApi.Lists

  describe "lists" do
    alias TrelloWebApi.Lists.List

    import TrelloWebApi.ListsFixtures

    @invalid_attrs %{name: nil, rank: nil}

    test "list_lists/0 returns all lists" do
      list = list_fixture()
      assert Lists.list_lists() == [list]
    end

    test "get_list!/1 returns the list with given id" do
      list = list_fixture()
      assert Lists.get_list!(list.id) == list
    end

    test "create_list/1 with valid data creates a list" do
      valid_attrs = %{name: "some name", rank: "some rank"}

      assert {:ok, %List{} = list} = Lists.create_list(valid_attrs)
      assert list.name == "some name"
      assert list.rank == "some rank"
    end

    test "create_list/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Lists.create_list(@invalid_attrs)
    end

    test "update_list/2 with valid data updates the list" do
      list = list_fixture()
      update_attrs = %{name: "some updated name", rank: "some updated rank"}

      assert {:ok, %List{} = list} = Lists.update_list(list, update_attrs)
      assert list.name == "some updated name"
      assert list.rank == "some updated rank"
    end

    test "update_list/2 with invalid data returns error changeset" do
      list = list_fixture()
      assert {:error, %Ecto.Changeset{}} = Lists.update_list(list, @invalid_attrs)
      assert list == Lists.get_list!(list.id)
    end

    test "delete_list/1 deletes the list" do
      list = list_fixture()
      assert {:ok, %List{}} = Lists.delete_list(list)
      assert_raise Ecto.NoResultsError, fn -> Lists.get_list!(list.id) end
    end

    test "change_list/1 returns a list changeset" do
      list = list_fixture()
      assert %Ecto.Changeset{} = Lists.change_list(list)
    end
  end
end
