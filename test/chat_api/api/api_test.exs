defmodule ChatApi.APITest do
  use ChatApi.DataCase

  alias ChatApi.API

  describe "users" do
    alias ChatApi.API.User

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> API.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert API.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert API.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = API.create_user(@valid_attrs)
      assert user.name == "some name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = API.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = API.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.name == "some updated name"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = API.update_user(user, @invalid_attrs)
      assert user == API.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = API.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> API.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = API.change_user(user)
    end
  end

  describe "chats" do
    alias ChatApi.API.Chat

    @valid_attrs %{is_private: true, name: "some name"}
    @update_attrs %{is_private: false, name: "some updated name"}
    @invalid_attrs %{is_private: nil, name: nil}

    def chat_fixture(attrs \\ %{}) do
      {:ok, chat} =
        attrs
        |> Enum.into(@valid_attrs)
        |> API.create_chat()

      chat
    end

    test "list_chats/0 returns all chats" do
      chat = chat_fixture()
      assert API.list_chats() == [chat]
    end

    test "get_chat!/1 returns the chat with given id" do
      chat = chat_fixture()
      assert API.get_chat!(chat.id) == chat
    end

    test "create_chat/1 with valid data creates a chat" do
      assert {:ok, %Chat{} = chat} = API.create_chat(@valid_attrs)
      assert chat.is_private == true
      assert chat.name == "some name"
    end

    test "create_chat/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = API.create_chat(@invalid_attrs)
    end

    test "update_chat/2 with valid data updates the chat" do
      chat = chat_fixture()
      assert {:ok, chat} = API.update_chat(chat, @update_attrs)
      assert %Chat{} = chat
      assert chat.is_private == false
      assert chat.name == "some updated name"
    end

    test "update_chat/2 with invalid data returns error changeset" do
      chat = chat_fixture()
      assert {:error, %Ecto.Changeset{}} = API.update_chat(chat, @invalid_attrs)
      assert chat == API.get_chat!(chat.id)
    end

    test "delete_chat/1 deletes the chat" do
      chat = chat_fixture()
      assert {:ok, %Chat{}} = API.delete_chat(chat)
      assert_raise Ecto.NoResultsError, fn -> API.get_chat!(chat.id) end
    end

    test "change_chat/1 returns a chat changeset" do
      chat = chat_fixture()
      assert %Ecto.Changeset{} = API.change_chat(chat)
    end
  end

  describe "user_subscription" do
    alias ChatApi.API.UserSubscrions

    @valid_attrs %{source: "some source", subscription: "some subscription"}
    @update_attrs %{source: "some updated source", subscription: "some updated subscription"}
    @invalid_attrs %{source: nil, subscription: nil}

    def user_subscrions_fixture(attrs \\ %{}) do
      {:ok, user_subscrions} =
        attrs
        |> Enum.into(@valid_attrs)
        |> API.create_user_subscrions()

      user_subscrions
    end

    test "list_user_subscription/0 returns all user_subscription" do
      user_subscrions = user_subscrions_fixture()
      assert API.list_user_subscription() == [user_subscrions]
    end

    test "get_user_subscrions!/1 returns the user_subscrions with given id" do
      user_subscrions = user_subscrions_fixture()
      assert API.get_user_subscrions!(user_subscrions.id) == user_subscrions
    end

    test "create_user_subscrions/1 with valid data creates a user_subscrions" do
      assert {:ok, %UserSubscrions{} = user_subscrions} = API.create_user_subscrions(@valid_attrs)
      assert user_subscrions.source == "some source"
      assert user_subscrions.subscription == "some subscription"
    end

    test "create_user_subscrions/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = API.create_user_subscrions(@invalid_attrs)
    end

    test "update_user_subscrions/2 with valid data updates the user_subscrions" do
      user_subscrions = user_subscrions_fixture()
      assert {:ok, user_subscrions} = API.update_user_subscrions(user_subscrions, @update_attrs)
      assert %UserSubscrions{} = user_subscrions
      assert user_subscrions.source == "some updated source"
      assert user_subscrions.subscription == "some updated subscription"
    end

    test "update_user_subscrions/2 with invalid data returns error changeset" do
      user_subscrions = user_subscrions_fixture()
      assert {:error, %Ecto.Changeset{}} = API.update_user_subscrions(user_subscrions, @invalid_attrs)
      assert user_subscrions == API.get_user_subscrions!(user_subscrions.id)
    end

    test "delete_user_subscrions/1 deletes the user_subscrions" do
      user_subscrions = user_subscrions_fixture()
      assert {:ok, %UserSubscrions{}} = API.delete_user_subscrions(user_subscrions)
      assert_raise Ecto.NoResultsError, fn -> API.get_user_subscrions!(user_subscrions.id) end
    end

    test "change_user_subscrions/1 returns a user_subscrions changeset" do
      user_subscrions = user_subscrions_fixture()
      assert %Ecto.Changeset{} = API.change_user_subscrions(user_subscrions)
    end
  end
end
