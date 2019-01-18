defmodule ChatApi.Repo.Migrations.CreateUserSubscriptions do
  use Ecto.Migration

  def change do
    create table(:user_subscriptions, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :source, :string
      add :subscription, :string
      add :user_id, references(:users, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create index(:user_subscriptions, [:user_id])
  end
end
