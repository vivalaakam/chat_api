defmodule ChatApiWeb.ChatView do
  use ChatApiWeb, :view
  alias ChatApiWeb.ChatView

  def render("index.json", %{chats: chats}) do
    %{data: render_many(chats, ChatView, "chat.json")}
  end

  def render("show.json", %{chat: chat}) do
    %{data: render_one(chat, ChatView, "chat.json")}
  end

  def render("chat.json", %{chat: chat}) do
    %{
      id: chat.id,
      name: chat.name,
      is_private: chat.is_private,
      users: render_many(chat.users, ChatApiWeb.UserView, "user.json")
    }
  end

  def render("show_messages.json", %{chat: chat}) do
    %{
      data: %{
        id: chat.id,
        name: chat.name,
        is_private: chat.is_private,
        messages: render_many(chat.messages, ChatApiWeb.MessageView, "message.json"),
        users: render_many(chat.users, ChatApiWeb.UserView, "user.json")
      }
    }
  end

  def render("messages.json", %{messages: messages}) do
    %{
      data: render_many(messages, ChatApiWeb.MessageView, "message.json")
    }
  end

  def render("message.json", %{message: message}) do
    %{
      data: render_one(message, ChatApiWeb.MessageView, "message.json")
    }
  end
end
