defmodule ChatApi.Repo.Migrations.AddGoogleToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :google_id, :string
      add :google_token, :string
    end
  end
end
