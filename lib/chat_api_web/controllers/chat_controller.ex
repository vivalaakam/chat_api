defmodule ChatApiWeb.ChatController do
  use ChatApiWeb, :controller

  alias ChatApi.API
  alias ChatApi.API.Chat
  alias ChatApi.API.User

  action_fallback ChatApiWeb.FallbackController

  def index(conn, _params) do
    current_user = conn
                   |> Guardian.Plug.current_resource

    chats = API.list_chats(current_user)
    render(conn, "index.json", chats: chats)
  end

  def create(conn, %{"chat" => chat_params}) do
    with {:ok, %Chat{} = chat} <- API.create_chat(chat_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", chat_path(conn, :show, chat))
      |> render("show.json", chat: chat)
    end
  end

  def show(conn, %{"id" => id}) do
    chat = API.get_chat!(id)
    render(conn, "show.json", chat: chat)
  end

  def update(conn, %{"id" => id, "chat" => chat_params}) do
    chat = API.get_chat!(id)

    with {:ok, %Chat{} = chat} <- API.update_chat(chat, chat_params) do
      render(conn, "show.json", chat: chat)
    end
  end

  def delete(conn, %{"id" => id}) do
    chat = API.get_chat!(id)
    with {:ok, %Chat{}} <- API.delete_chat(chat) do
      send_resp(conn, :no_content, "")
    end
  end
end
