defmodule TrelloWebApi.BoardsTest do
  use TrelloWebApi.DataCase

  alias TrelloWebApi.Boards

  describe "boards" do
    alias TrelloWebApi.Boards.Board

    import TrelloWebApi.BoardsFixtures

    @invalid_attrs %{name: nil, visibility: nil}

    test "list_boards/0 returns all boards" do
      board = board_fixture()
      assert Boards.list_boards() == [board]
    end

    test "get_board!/1 returns the board with given id" do
      board = board_fixture()
      assert Boards.get_board!(board.id) == board
    end

    test "create_board/1 with valid data creates a board" do
      valid_attrs = %{name: "some name", visibility: :private}

      assert {:ok, %Board{} = board} = Boards.create_board(valid_attrs)
      assert board.name == "some name"
      assert board.visibility == :private
    end

    test "create_board/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Boards.create_board(@invalid_attrs)
    end

    test "update_board/2 with valid data updates the board" do
      board = board_fixture()
      update_attrs = %{name: "some updated name", visibility: :public}

      assert {:ok, %Board{} = board} = Boards.update_board(board, update_attrs)
      assert board.name == "some updated name"
      assert board.visibility == :public
    end

    test "update_board/2 with invalid data returns error changeset" do
      board = board_fixture()
      assert {:error, %Ecto.Changeset{}} = Boards.update_board(board, @invalid_attrs)
      assert board == Boards.get_board!(board.id)
    end

    test "delete_board/1 deletes the board" do
      board = board_fixture()
      assert {:ok, %Board{}} = Boards.delete_board(board)
      assert_raise Ecto.NoResultsError, fn -> Boards.get_board!(board.id) end
    end

    test "change_board/1 returns a board changeset" do
      board = board_fixture()
      assert %Ecto.Changeset{} = Boards.change_board(board)
    end
  end

  describe "board_users" do
    alias TrelloWebApi.Boards.BoardUser

    import TrelloWebApi.BoardsFixtures

    @invalid_attrs %{permission: nil}

    test "list_board_users/0 returns all board_users" do
      board_user = board_user_fixture()
      assert Boards.list_board_users() == [board_user]
    end

    test "get_board_user!/1 returns the board_user with given id" do
      board_user = board_user_fixture()
      assert Boards.get_board_user!(board_user.id) == board_user
    end

    test "create_board_user/1 with valid data creates a board_user" do
      valid_attrs = %{permission: :manage}

      assert {:ok, %BoardUser{} = board_user} = Boards.create_board_user(valid_attrs)
      assert board_user.permission == :manage
    end

    test "create_board_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Boards.create_board_user(@invalid_attrs)
    end

    test "update_board_user/2 with valid data updates the board_user" do
      board_user = board_user_fixture()
      update_attrs = %{permission: :write}

      assert {:ok, %BoardUser{} = board_user} = Boards.update_board_user(board_user, update_attrs)
      assert board_user.permission == :write
    end

    test "update_board_user/2 with invalid data returns error changeset" do
      board_user = board_user_fixture()
      assert {:error, %Ecto.Changeset{}} = Boards.update_board_user(board_user, @invalid_attrs)
      assert board_user == Boards.get_board_user!(board_user.id)
    end

    test "delete_board_user/1 deletes the board_user" do
      board_user = board_user_fixture()
      assert {:ok, %BoardUser{}} = Boards.delete_board_user(board_user)
      assert_raise Ecto.NoResultsError, fn -> Boards.get_board_user!(board_user.id) end
    end

    test "change_board_user/1 returns a board_user changeset" do
      board_user = board_user_fixture()
      assert %Ecto.Changeset{} = Boards.change_board_user(board_user)
    end
  end
end
