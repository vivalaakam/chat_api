defmodule ChatApi.API.User do
  use ChatApiWeb, :model

  schema "users" do
    field :name, :string
    field :fb_id, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :fb_id])
    |> validate_required([:name])
  end
end
