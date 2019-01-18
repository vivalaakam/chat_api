defmodule ChatApi.API.User do
  use ChatApiWeb, :model

  schema "users" do
    field :name, :string
    field :fb_id, :string
    field :fb_token, :string

    many_to_many :chats,  ChatApi.API.Chat, join_through: "chat_users"
    has_many :subscriptions, ChatAPI.UserSubscription

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :fb_id, :fb_token])
    |> validate_required([:name])
  end
end
