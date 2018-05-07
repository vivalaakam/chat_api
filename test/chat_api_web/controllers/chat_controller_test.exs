defmodule ChatApiWeb.ChatControllerTest do
  use ChatApiWeb.ConnCase

  alias ChatApi.API
  alias ChatApi.API.Chat

  @create_attrs %{is_private: true, name: "some name"}
  @update_attrs %{is_private: false, name: "some updated name"}
  @invalid_attrs %{is_private: nil, name: nil}

  def fixture(:chat) do
    {:ok, chat} = API.create_chat(@create_attrs)
    chat
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all chats", %{conn: conn} do
      conn = get conn, chat_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create chat" do
    test "renders chat when data is valid", %{conn: conn} do
      conn = post conn, chat_path(conn, :create), chat: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, chat_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "is_private" => true,
        "name" => "some name"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, chat_path(conn, :create), chat: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update chat" do
    setup [:create_chat]

    test "renders chat when data is valid", %{conn: conn, chat: %Chat{id: id} = chat} do
      conn = put conn, chat_path(conn, :update, chat), chat: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, chat_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "is_private" => false,
        "name" => "some updated name"}
    end

    test "renders errors when data is invalid", %{conn: conn, chat: chat} do
      conn = put conn, chat_path(conn, :update, chat), chat: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete chat" do
    setup [:create_chat]

    test "deletes chosen chat", %{conn: conn, chat: chat} do
      conn = delete conn, chat_path(conn, :delete, chat)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, chat_path(conn, :show, chat)
      end
    end
  end

  defp create_chat(_) do
    chat = fixture(:chat)
    {:ok, chat: chat}
  end
end
