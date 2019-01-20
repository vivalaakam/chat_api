defmodule ChatApi.Repo.Migrations.AddPasswordToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :email, :string
      add :password, :string
    end
  end
end
