defmodule ChatApi.Repo.Migrations.CreateChatMessages do
  use Ecto.Migration

  def change do
    create table(:chat_messages, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :message, :string
      add :chat_id, references(:chats, on_delete: :nothing, type: :uuid)
      add :sender_id, references(:users, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create index(:chat_messages, [:chat_id])
    create index(:chat_messages, [:sender_id])
  end
end
