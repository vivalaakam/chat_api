defmodule ChatApiWeb.ChatController do
  use ChatApiWeb, :controller

  alias ChatApi.API
  alias ChatApi.API.Chat
  alias ChatApi.API.ChatMessage
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
    chat = API.get_chat_with_messages!(id)
    render(conn, "show_messages.json", chat: chat)
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

  def messages(conn, %{"id" => id, "last_message" => last_message}) do
    messages = API.get_chat_messages(id, last_message)
    render(conn, "messages.json", messages: messages)
  end

  def message(conn, %{"id" => id, "message" => message_params}) do
    chat = API.get_chat!(id)

    current_user = conn
                   |> Guardian.Plug.current_resource

    message_params = Map.put(message_params, "chat", chat)
    message_params = Map.put(message_params, "sender", current_user)


    with {:ok, %ChatMessage{} = message} <- API.create_message(message_params) do
      ChatApiWeb.Endpoint.broadcast(
        "chat:" <> message.chat_id,
        "on_message",
        %{
          id: message.id,
          message: message.message,
          inserted_at: message.inserted_at,
          sender_id: message.sender_id
        }
      )

      conn
      |> put_status(:created)
      |> render("message.json", message: message)
    end
  end
end
