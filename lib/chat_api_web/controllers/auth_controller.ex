defmodule ChatApiWeb.AuthController do
  use ChatApiWeb, :controller
  plug Ueberauth

  alias ChatApi.API
  alias ChatApi.API.User

  import Plug.Conn

  alias Ueberauth.Strategy.Helpers

  def me(conn, _params) do
    current_user = conn
                   |> Guardian.Plug.current_resource

    user = API.get_user!(current_user.id)
    conn
    |> render("me.json", user: user)
  end

  def auth_fb(conn, %{"auth" => user_params}) do
    user = API.get_fb_user(user_params["fb_id"])
    auth(conn, user, user_params, "user.json")
  end

  def auth(conn, user, user_params, screen) when user == nil do
    with {:ok, %User{} = user} <- API.create_user(user_params) do
      auth(conn, user, user_params, screen)
    end
  end

  def auth(conn, user, _, screen) do
    {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user, :api)

    conn
    |> Guardian.Plug.sign_in(user)
    |> assign(:current_user, user)
    |> render(screen, user: user, token: jwt)
  end

  def logout(conn, _params) do
    # Sign out the user
    conn
    |> put_status(200)
    |> Guardian.Plug.sign_out(conn)
    |> render("logout.json")
  end

  def request(conn, _params) do

    conn = put_layout conn, "auth.html"
    render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  end

  def callback(
        %{
          assigns: %{
            ueberauth_failure: _fails
          }
        } = conn,
        _params
      ) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(
        %{
          assigns: %{
            ueberauth_auth: auth
          }
        } = conn,
        %{"provider" => provider}
      ) do

    conn = put_layout conn, false

    case provider do
      "facebook" ->
        user = API.get_fb_user(auth.uid)
        user_params = %{fb_id: auth.uid, name: auth.info.name, fb_token: auth.credentials.token}
      "google" ->
        user = API.get_google_user(auth.uid)
        user_params = %{google_id: auth.uid, name: auth.info.name, google_token: auth.credentials.token}
    end
    auth(conn, user, user_params, "close.html")
  end

  def identity_callback(
        %{
          assigns: %{
            ueberauth_auth: auth
          }
        } = conn,
        _params
      ) do
    IO.inspect(auth)
    user = API.get_email_user(auth.uid)

    unless user do
      user_params = %{email: auth.uid, name: auth.uid, password: auth.credentials.other.password}
      conn = put_layout conn, false
      auth(conn, user, user_params, "close.html")
    end


    case API.check_password(user, auth.credentials.other.password) do
      {:ok, user} ->
        conn = put_layout conn, false
        auth(conn, user, %{}, "close.html")
      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/auth/identity")
    end
  end
end
