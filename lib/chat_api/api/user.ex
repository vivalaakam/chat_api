defmodule ChatApi.API.User do
  use ChatApiWeb, :model
  alias Comeonin.Bcrypt

  schema "users" do
    field :name, :string
    field :fb_id, :string
    field :fb_token, :string
    field :google_id, :string
    field :google_token, :string
    field :email, :string
    field :password, :string

    many_to_many :chats, ChatApi.API.Chat, join_through: "chat_users"

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :fb_id, :fb_token, :google_id, :google_token, :email, :password])
    |> validate_required([:name])
    |> put_pass_hash()
  end

  defp put_pass_hash(
         %Ecto.Changeset{
           valid?: true,
           changes: %{
             password: password
           }
         } = changeset
       ) do
    change(changeset, password: Bcrypt.hashpwsalt(password))
  end
  defp put_pass_hash(changeset), do: changeset
end
