defmodule ChatApiWeb.UserSubscriptionController do
  use ChatApiWeb, :controller

  alias ChatApi.API
  alias ChatApi.API.UserSubscription

  action_fallback ChatApiWeb.FallbackController

  def index(conn, _params) do
    current_user = conn
                   |> Guardian.Plug.current_resource

    user_subscriptions = API.list_user_subscriptions(current_user)
    render(conn, "index.json", user_subscriptions: user_subscriptions)
  end

  def create(conn, %{"subscription" => user_subscription_params}) do
    current_user = conn
                   |> Guardian.Plug.current_resource

    user_subscription_params = Map.put(user_subscription_params, "user", current_user)
    # user_subscription_params = Map.put(user_subscription_params, "subscription" , Poison.encode!(user_subscription_params["subscription"]))

    with {:ok, %UserSubscription{} = user_subscription} <- API.create_user_subscription(user_subscription_params) do
      conn
      |> put_status(:created)
      |> render("show.json", user_subscription: user_subscription)
    end
  end

  def show(conn, %{"id" => id}) do
    user_subscription = API.get_user_subscription!(id)
    render(conn, "show.json", user_subscription: user_subscription)
  end

  def update(conn, %{"id" => id, "user_subscription" => user_subscription_params}) do
    user_subscription = API.get_user_subscription!(id)

    with {:ok, %UserSubscription{} = user_subscription} <- API.update_user_subscription(
      user_subscription,
      user_subscription_params
    ) do
      render(conn, "show.json", user_subscription: user_subscription)
    end
  end

  def delete(conn, %{"id" => id}) do
    user_subscription = API.get_user_subscription!(id)
    with {:ok, %UserSubscription{}} <- API.delete_user_subscription(user_subscription) do
      send_resp(conn, :no_content, "")
    end
  end
end
