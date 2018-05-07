defmodule ChatApi.API.ChatUser do
  use Ecto.Schema
  use ChatApiWeb, :model
  import Ecto.Changeset


  schema "chat_users" do
    belongs_to :user, ChatApi.API.User
    belongs_to :chat, ChatApi.API.Chat
  end

  @doc false
  def changeset(chat_user, attrs) do
    chat_user
    |> cast(attrs, [])
    |> validate_required([])
  end
end
