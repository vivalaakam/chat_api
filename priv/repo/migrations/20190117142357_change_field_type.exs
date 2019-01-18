defmodule ChatApi.Repo.Migrations.ChangeFieldType do
  use Ecto.Migration

  def change do
    alter table(:user_subscriptions) do
      modify :subscription, :text
    end
  end
end
