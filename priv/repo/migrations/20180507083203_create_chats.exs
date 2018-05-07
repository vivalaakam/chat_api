defmodule ChatApi.Repo.Migrations.CreateChats do
  use Ecto.Migration

  def change do
    create table(:chats, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :is_private, :boolean, default: false, null: false

      timestamps()
    end

  end
end
