defmodule ChatApiWeb.UserController do
  use ChatApiWeb, :controller

  alias ChatApi.API
  alias ChatApi.API.User

  action_fallback ChatApiWeb.FallbackController

  def index(conn, _params) do
    users = API.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- API.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = API.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = API.get_user!(id)

    with {:ok, %User{} = user} <- API.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = API.get_user!(id)
    with {:ok, %User{}} <- API.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
