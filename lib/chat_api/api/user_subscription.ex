defmodule ChatApi.API.UserSubscription do
  use Ecto.Schema
  use ChatApiWeb, :model
  import Ecto.Changeset


  schema "user_subscriptions" do
    field :source, :string
    field :subscription, :string
    belongs_to :user, ChatApi.API.User

    timestamps()
  end

  @doc false
  def changeset(user_subscription, attrs) do
    user_subscription
    |> cast(attrs, [:source, :subscription])
    |> put_assoc(:user, attrs["user"])
    |> validate_required([:source, :subscription])
  end
end
