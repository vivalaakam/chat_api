defmodule ChatApiWeb.MessageView do
  use ChatApiWeb, :view
  alias ChatApiWeb.MessageView
  @moduledoc false

  def render("message.json", %{message: message}) do
    %{
      id: message.id,
      message: message.message,
      inserted_at: message.inserted_at,
      sender_id: message.sender_id
    }
  end
end
