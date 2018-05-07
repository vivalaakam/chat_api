defmodule ChatApi.Repo.Migrations.AddFbTokenToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :fb_token, :string
    end
  end
end
