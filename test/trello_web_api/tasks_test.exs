defmodule TrelloWebApi.TasksTest do
  use TrelloWebApi.DataCase

  alias TrelloWebApi.Tasks

  describe "tasks" do
    alias TrelloWebApi.Tasks.Task

    import TrelloWebApi.TasksFixtures

    @invalid_attrs %{name: nil, details: nil, rank: nil, completed: nil}

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Tasks.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Tasks.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      valid_attrs = %{name: "some name", details: "some details", rank: "some rank", completed: true}

      assert {:ok, %Task{} = task} = Tasks.create_task(valid_attrs)
      assert task.name == "some name"
      assert task.details == "some details"
      assert task.rank == "some rank"
      assert task.completed == true
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      update_attrs = %{name: "some updated name", details: "some updated details", rank: "some updated rank", completed: false}

      assert {:ok, %Task{} = task} = Tasks.update_task(task, update_attrs)
      assert task.name == "some updated name"
      assert task.details == "some updated details"
      assert task.rank == "some updated rank"
      assert task.completed == false
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Tasks.update_task(task, @invalid_attrs)
      assert task == Tasks.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Tasks.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Tasks.change_task(task)
    end
  end

  describe "comments" do
    alias TrelloWebApi.Tasks.Comment

    import TrelloWebApi.TasksFixtures

    @invalid_attrs %{body: nil}

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert Tasks.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert Tasks.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      valid_attrs = %{body: "some body"}

      assert {:ok, %Comment{} = comment} = Tasks.create_comment(valid_attrs)
      assert comment.body == "some body"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      update_attrs = %{body: "some updated body"}

      assert {:ok, %Comment{} = comment} = Tasks.update_comment(comment, update_attrs)
      assert comment.body == "some updated body"
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture()
      assert {:error, %Ecto.Changeset{}} = Tasks.update_comment(comment, @invalid_attrs)
      assert comment == Tasks.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = Tasks.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = Tasks.change_comment(comment)
    end
  end
end
