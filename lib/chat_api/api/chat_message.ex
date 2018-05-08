defmodule ChatApi.API.ChatMessage do
  use Ecto.Schema
  use ChatApiWeb, :model
  import Ecto.Changeset


  schema "chat_messages" do
    field :message, :string
    belongs_to :sender, ChatApi.API.User
    belongs_to :chat, ChatApi.API.Chat

    timestamps()
  end

  @doc false
  def changeset(chat_message, attrs) do
    chat_message
    |> cast(attrs, [:message])
    |> put_assoc(:sender, attrs["sender"])
    |> put_assoc(:chat, attrs["chat"])
    |> validate_required([:message])
  end
end
