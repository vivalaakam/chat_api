defmodule ChatApi.Repo.Migrations.AddHashToChats do
  use Ecto.Migration

  def change do
    alter table(:chats) do
      add :hash, :string
    end
  end
end
