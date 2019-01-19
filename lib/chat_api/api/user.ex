defmodule ChatApi.API.User do
  use ChatApiWeb, :model

  schema "users" do
    field :name, :string
    field :fb_id, :string
    field :fb_token, :string
    field :google_id, :string
    field :google_token, :string

    many_to_many :chats, ChatApi.API.Chat, join_through: "chat_users"

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :fb_id, :fb_token, :google_id, :google_token])
    |> validate_required([:name])
  end
end
