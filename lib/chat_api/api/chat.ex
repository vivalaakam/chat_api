defmodule ChatApi.API.Chat do
  use Ecto.Schema
  use ChatApiWeb, :model
  import Ecto.Changeset


  schema "chats" do
    field :is_private, :boolean, default: false
    field :name, :string

    has_many :messages, ChatApi.API.ChatMessage
    many_to_many :users, ChatApi.API.User, join_through: "chat_users"

    has_one :last_message, ChatApi.API.ChatMessage
    timestamps()
  end

  @doc false
  def changeset(chat, attrs) do
    chat
    |> cast(attrs, [:name, :is_private])
    |> put_assoc(:users, parse_users(attrs))
    |> validate_required([:name, :is_private])
  end

  defp parse_users(attrs) do
    attrs["users"]
    |> Enum.map(fn (id) -> ChatApi.API.get_user!(id) end)
  end

end
