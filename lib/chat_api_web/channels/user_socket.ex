defmodule ChatApiWeb.UserSocket do
  use Phoenix.Socket
  import Guardian.Phoenix.Socket


  channel "chat:*", ChatApiWeb.ChatChannel
  channel "user:*", ChatApiWeb.UserChannel
  transport :websocket, Phoenix.Transports.WebSocket

  def connect(%{"guardian_token" => jwt} = params, socket) do
    IO.inspect(jwt)
    case sign_in(socket, jwt) do
      {:ok, authed_socket, guardian_params} ->
        {:ok, authed_socket}
      _ -> :error
    end
  end

  def id(_socket), do: nil
end
