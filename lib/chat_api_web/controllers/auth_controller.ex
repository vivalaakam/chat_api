defmodule ChatApiWeb.AuthController do
  use ChatApiWeb, :controller

  alias ChatApi.API
  alias ChatApi.API.User

  import Plug.Conn

  def me(conn, _params) do
    current_user = conn
                   |> Guardian.Plug.current_resource

    user = API.get_user!(current_user.id)
    conn
    |> render("me.json", user: user)
  end

  def auth_fb(conn, %{"auth" => user_params}) do
    user = API.get_fb_user(user_params["fb_id"])
    auth(conn, user, user_params)
  end

  def auth(conn, user, user_params) when user == nil do
    with {:ok, %User{} = user} <- API.create_user(user_params) do
      auth(conn, user, user_params)
    end
  end

  def auth(conn, user, _) do
    {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user, :api)

    conn
    |> Guardian.Plug.sign_in(user)
    |> assign(:current_user, user)
    |> render("user.json", user: user, token: jwt)
  end

  def logout(conn, _params) do
    # Sign out the user
    conn
    |> put_status(200)
    |> Guardian.Plug.sign_out(conn)
    |> render("logout.json")
  end
end
